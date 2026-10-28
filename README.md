# Examination Schedule and Management System (ESMS)

**Examinations, organized.**
*Simplifying examinations. Organizing academics. Empowering students.*

A centralized university examination schedule and records management platform built for second-year B.Tech CSE Project Based Learning (PBL). It provides role-based workspaces for Students, Faculty, and Examination Administrators, complete with scheduling conflict detection, marks worksheet entry, persistent SQLite database storage, and standalone academic Data Structures & Algorithms (C) and Object-Oriented Programming (C++) modules.

---

## 1. Demo Credentials (Ready to Test)

The system is pre-seeded with working accounts for each role. Passwords are encrypted using server-side **bcrypt** password hashing.

| Role | University ID | Password | Access Scope |
|---|---|---|---|
| **Admin** | `ADMIN001` | `Admin@123` | Full administrative authority: Student CRUD, Faculty CRUD, Subject CRUD, Exam Scheduling with room/invigilator conflict detection, Results Overview |
| **Faculty** | `FAC201` | `Faculty@123` | Dr. Rajesh Sharma: Assigned subjects (CS401, CS404), student rosters, scheduling subject assessments, spreadsheet marks entry and publishing |
| **Student** | `STU100` | `Student@123` | Aarav Patel (Sem 4 CSE): Academic profile, enrolled subjects & credits, examination timetable with highlighted upcoming tests, published results transcript |

---

## 2. System Architecture

```
ESMS/
├── server.ts                   # Express server entry point with Vite middleware
├── server/
│   ├── db.ts                   # SQLite persistent database & idempotent seeder
│   ├── auth.ts                 # Bcrypt hashing, token validation & RBAC middleware
│   └── routes/api.ts           # REST API endpoints (Auth, Students, Faculty, Subjects, Exams, Marks)
├── src/
│   ├── context/AuthContext.tsx # React authentication provider & session state
│   ├── services/api.ts         # Type-safe client API service layer
│   ├── types/index.ts          # TypeScript domain interfaces
│   ├── components/             # Navbar, Sidebar, ConfirmModal, Toast notifications
│   └── pages/
│       ├── LoginPage.tsx       # Branded split-screen login with demo credentials autofill
│       ├── admin/              # Dashboard, Students, Faculty, Subjects, Exams, Results
│       ├── faculty/            # Dashboard, Subjects, Students, Exam Schedules, Marks Entry
│       ├── student/            # Dashboard, Profile, Enrolled Subjects, Timetable, Results
│       └── academic/           # C DSA & C++ OOP interactive viva code browser
├── data/
│   └── esms.db                 # Persistent SQLite database file
├── academic-c-dsa/             # Academic C DSA source files
│   ├── student_records_linkedlist.c # Dynamic Singly Linked List (Insertion, Deletion, Search, File I/O)
│   ├── exam_schedule_sort_search.c  # Array of structures, QuickSort, BubbleSort, Conflict Detection
│   ├── Makefile                # GCC compilation targets
│   └── README.md               # DSA complexity analysis & compilation guide
├── academic-cpp-oop/           # Academic C++ OOP source files
│   ├── esms_oop_system.cpp     # User hierarchy, inheritance, polymorphism, fstream persistence
│   ├── Makefile                # G++ compilation targets
│   └── README.md               # OOP concepts mapping & viva questions
└── package.json
```

---

## 3. Key Features

### Role-Based Authorization & Workspaces
- **Admin Workspace:** KPI cards, live system activity audit log, full student enrollment CRUD, faculty hiring and subject assignments, curriculum credits mapping, examination timetable creation with real-time conflict checking, and grade sheet publishing overview.
- **Faculty Workspace:** Personal dashboard showing assigned subjects, enrolled semester students, exam schedule management for authorized courses, spreadsheet-style student marks entry with $[0, \text{maxMarks}]$ bounds validation, and instant publishing.
- **Student Workspace:** Next examination highlight banner, enrolled courses and credit weightages, searchable examination timetable filtered by exam type and date, and verified published results transcript with cumulative percentage and GPA estimator.

### Real-Time Examination Conflict Detection
Prevents double-booking:
- **Room Conflict:** Rejects scheduling two examinations in the same room on the same date where start and end time intervals overlap: $(s_1 < e_2) \land (s_2 < e_1)$.
- **Faculty Invigilator Conflict:** Rejects assigning the same faculty examiner to two different rooms simultaneously.

---

## 4. Academic Modules (C DSA & C++ OOP)

The academic source files compile and execute independently via GCC and G++:

### C Data Structures and Algorithms (`academic-c-dsa/`)
1. **Dynamic Memory & Singly Linked List (`student_records_linkedlist.c`):**
   - Node allocation via `malloc()` and dynamic deallocation via `free()`.
   - Sorted insertion in $O(N)$ maintaining alphabetical/numerical order of Student ID.
   - Deletion by Student ID in $O(N)$ with pointer reconnection.
   - Linear search and persistent CSV saving/loading.
2. **Array Algorithms & Conflict Checking (`exam_schedule_sort_search.c`):**
   - Chronological QuickSort ($O(N \log N)$ average).
   - Alphabetical BubbleSort by Subject Code with early termination optimization.
   - Binary Search for examination IDs on sorted data.
   - Mathematical interval conflict detection algorithm.

### C++ Object-Oriented Programming (`academic-cpp-oop/`)
1. **Encapsulation:** Private attributes with accessor and mutator methods.
2. **Inheritance:** Abstract base class `User` extended by derived classes `Student`, `Faculty`, and `Admin`.
3. **Runtime Polymorphism:** Pure virtual method `virtual std::string getRole() const = 0` and virtual method `virtual void displayDashboard() const;` dynamically dispatched via base class pointers (`std::vector<std::shared_ptr<User>>`).
4. **File Serialization:** Streams (`std::ofstream`, `std::ifstream`) saving and loading records.

---

## 5. Running and Compiling

### Full-Stack Web Application
```bash
# Install dependencies
npm install

# Start full-stack server (port 3000)
npm run dev

# Build for production
npm run build
npm run start
```

### Academic C Programs (GCC)
```bash
cd academic-c-dsa
make
# or manually:
gcc -Wall -Wextra -O2 student_records_linkedlist.c -o student_records_linkedlist
gcc -Wall -Wextra -O2 exam_schedule_sort_search.c -o exam_schedule_sort_search

./student_records_linkedlist
./exam_schedule_sort_search
```

### Academic C++ Program (G++)
```bash
cd academic-cpp-oop
make
# or manually:
g++ -Wall -Wextra -O2 -std=c++17 esms_oop_system.cpp -o esms_oop_system

./esms_oop_system
```

---

## 6. Verification & Test Report

| Module | Test Case | Status | Notes |
|---|---|---|---|
| Auth | Admin Login (`ADMIN001`) | **PASSED** | Validated via bcrypt, routed to Admin Dashboard |
| Auth | Faculty Login (`FAC201`) | **PASSED** | Validated via bcrypt, routed to Faculty Dashboard |
| Auth | Student Login (`STU100`) | **PASSED** | Validated via bcrypt, routed to Student Dashboard |
| Auth | Incorrect Password | **PASSED** | Rejected with 401 and user-friendly error message |
| Conflict Engine | Same room overlapping time | **PASSED** | Caught and blocked with clear error message |
| Conflict Engine | Same faculty overlapping time | **PASSED** | Caught and blocked with clear error message |
| Marks Entry | Input validation ($0 \le m \le \text{max}$) | **PASSED** | Negative or out-of-range values blocked |
| Marks Entry | Publish status | **PASSED** | Transferred from draft to published, visible to student |
| C DSA | GCC Compilation | **PASSED** | 0 warnings, linked list & quicksort verified |
| C++ OOP | G++ Compilation | **PASSED** | 0 warnings, polymorphic dispatch verified |
| Web Build | `npm run build` | **PASSED** | TypeScript bundle verified cleanly |

## One-click launch on Windows
1. Extract the ZIP completely.
2. Double-click `Launch-ESMS.bat`. On the first run, it installs Node.js package dependencies (internet required), starts the server, and opens `http://localhost:3000` in your default browser.
3. Keep the server command window open while using/presenting the website. Close that window to stop the server.

Prerequisite: install Node.js LTS from https://nodejs.org/ if it is not already installed.
