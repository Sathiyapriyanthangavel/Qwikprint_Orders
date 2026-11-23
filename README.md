# QwikPrint – Franchise Orders Management System

A responsive, full-screen web application designed to manage QwikPrint franchise orders, payments, installation schedules, incentives, users, and business reports.

The application provides a centralized platform for administrators and franchise operations users to track every franchise order from booking to installation.

---

## 🚀 Features

### 1. Authentication & User Management
- Secure login using Supabase Authentication.
- Role-based access control (Admin and User).
- Admin can create and manage user accounts.
- Activate or deactivate user accounts.
- User-specific order visibility.
- Password visibility toggle.

### 2. Franchise Order Management
- Create and manage franchise orders.
- Support for multiple kiosk models:
  - MINI
  - PRO
  - Lite
  - Custom
- Capture franchise location, owner name, phone number, and city.
- Record booking date and installation date.
- Automatically calculate the default installation date (25 days after booking).
- Add order notes.
- Track order status:
  - Order received
  - Shipped
  - Installed

### 3. Payment Management
- Automatically record ₹50,000 as the booking advance.
- Track additional payments received.
- Automatically calculate outstanding balances.
- Add subsequent payments.
- Support payment corrections through positive or negative adjustments.
- Prevent payments from exceeding the order value or going below zero.

### 4. Franchise Pricing Configuration

| Model | Total Price | Booking Advance | Remaining |
|---|---:|---:|---:|
| MINI | ₹1,65,000 | ₹50,000 | ₹1,15,000 |
| PRO | ₹3,50,000 | ₹50,000 | ₹3,00,000 |
| Lite | ₹2,50,000 | ₹50,000 | ₹2,00,000 |
| Custom | Customizable | ₹50,000 | Based on order value |

*Note: The booking advance is recorded as received when a new order is created.*

### 5. Incentive Tracking
- Track franchise order incentives.
- Incentive statuses:
  - Credited
  - Pending
- Admin can update incentive status.
- Users can view their incentive status.

### 6. Reports & Analytics
- Dashboard statistics:
  - Total orders
  - Total order value
  - Total payments received
  - Outstanding balance
- Model-wise reports.
- Month-wise reports.
- User-wise reports.
- Filter reports by model, month, and user.

### 7. Excel Export
- Export reports into Excel format.
- Generate separate worksheets for:
  - Model-wise reports
  - Month-wise reports
  - User-wise reports
  - All orders
- Export filtered order details.

### 8. Responsive Full-Screen UI
- Full-width dashboard layout.
- Full-screen login interface.
- QwikPrint green and white branding.
- Responsive desktop, tablet, and mobile layouts.
- Optimized tables with horizontal scrolling.
- Improved dashboard cards and navigation.

---

## 🛠️ Technology Stack

| Technology | Purpose |
|---|---|
| HTML5 | Application structure |
| CSS3 | Responsive UI and styling |
| JavaScript | Application logic |
| Supabase | Backend and database |
| Supabase Auth | User authentication |
| PostgreSQL | Database |
| SheetJS (XLSX) | Excel report generation |

---

## 📁 Project Structure

```text
QwikPrint-Franchise-Orders/
│
├── index.html
│
├── README.md
│
└── database/
    └── schema.sql
```

*The database folder is optional and should be included if you maintain your Supabase schema in the repository.*

---

## ⚙️ Installation & Setup

### Prerequisites

- Supabase account.
- Supabase project.
- Modern web browser.
- Code editor (VS Code recommended).
- Local web server or static hosting.

### Step 1: Clone the Repository

```bash
git clone YOUR_GITHUB_REPOSITORY_URL
```

Navigate to the project directory:

```bash
cd QwikPrint-Franchise-Orders
```

### Step 2: Configure Supabase

1. Open your Supabase project.
2. Navigate to **Project Settings → API**.
3. Copy your Project URL.
4. Copy your publishable key.

Update the following configuration in `index.html`:

```javascript
const SUPABASE_URL = "YOUR_SUPABASE_PROJECT_URL";
const SUPABASE_KEY = "YOUR_SUPABASE_PUBLISHABLE_KEY";
```

**Security note:** Only use the Supabase publishable key in browser-side code. Never expose your Supabase secret or service-role key.

### Step 3: Configure the Database

The application uses the existing Supabase database schema.

Required tables:

**profiles**

| Column | Purpose |
|---|---|
| id | User ID linked to Supabase Auth |
| name | User name |
| email | User email |
| role | Admin or User |
| active | Account activation status |
| created_at | Account creation timestamp |

**orders**

| Column | Purpose |
|---|---|
| id | Order ID |
| franchise | Franchise location |
| owner | Franchise owner |
| phone | Contact number |
| city | Franchise city |
| model | Kiosk model |
| total | Total order value |
| pre | Initial payment component |
| post | Remaining payment component |
| paid | Total payment received |
| booked | Booking date |
| install_date | Installation date |
| notes | Order notes |
| status | Order status |
| incentive | Incentive status |
| created_by | User who created the order |

The `profiles` table should have a relationship with Supabase Authentication. The `orders.created_by` column should reference the appropriate user ID.

**Important:** Use your existing `schema.sql` as the source of truth. The tables and columns above describe the application's expected data structure; they are not a replacement for your actual schema. Configure Row Level Security (RLS) policies to enforce admin and user permissions.

### Step 4: Run the Application

Open `index.html` using a local development server.

Recommended VS Code extension:

- Live Server

Alternatively, run:

```bash
python -m http.server 8000
```

Open your browser:

```text
http://localhost:8000
```

---

## 🔐 User Roles & Permissions

| Feature | Admin | User |
|---|:---:|:---:|
| Login | ✓ | ✓ |
| View all orders | ✓ | — |
| View own orders | ✓ | ✓ |
| Create new orders | ✓ | ✓ |
| Update order status | ✓ | ✓ |
| Update installation date | ✓ | ✓ |
| Record payments | ✓ | ✓ |
| Update incentives | ✓ | — |
| View reports | ✓ | — |
| Export Excel reports | ✓ | — |
| Manage users | ✓ | — |

*These are the intended application-level permissions. Enforce corresponding permissions through Supabase RLS policies and secure backend functions, not just frontend visibility.*

---

## 📊 Application Workflow

```text
User Login
    |
    v
Create Franchise Order
    |
    v
Record ₹50,000 Advance
    |
    v
Order Received
    |
    v
Payment Tracking
    |
    v
Order Shipped
    |
    v
Installation
    |
    v
Order Completed
    |
    v
Incentive Tracking & Reports
```

---

## 🌐 Deployment

The application can be deployed using:

- GitHub Pages
- Netlify
- Vercel
- Any static web hosting provider

Before deployment:

1. Configure the correct Supabase project URL and publishable key.
2. Verify database tables and relationships.
3. Configure and test Supabase RLS policies.
4. Test login and user permissions.
5. Verify order creation and payment updates.
6. Test Excel exports.
7. Test the application on desktop and mobile.

---

## 🔒 Security Considerations

- Use Supabase Authentication for account management.
- Never expose service-role or secret API keys.
- Enable Row Level Security on database tables.
- Restrict users to their authorized records.
- Restrict user management and administrative operations to admins.
- Validate payment and order updates on the trusted backend.
- Protect user creation operations using a secure server-side function.

---

## 👨‍💻 Project Information

**Project:** QwikPrint Franchise Orders Management System

**Organization:** QwikPrint

**Application Type:** Web-based Management System

**Backend:** Supabase

**Frontend:** HTML, CSS & JavaScript

**Purpose:** Centralized franchise order, payment, installation, incentive, and reporting management.

---

## 📌 Future Enhancements

- Payment history and transaction audit logs.
- Automated payment reminders.
- WhatsApp notifications for order updates.
- Franchise-wise performance analytics.
- PDF invoice generation.
- Advanced dashboard charts.
- Activity logs and admin audit tracking.
- Automated installation notifications.

---

**QwikPrint – The Future of Printing.**
