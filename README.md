# Najimul Islam Ahmed — Portfolio + Admin Console

    index.html        -> the website            (yourdomain.com)
    admin/index.html  -> the admin dashboard    (yourdomain.com/admin)

Both files are fully self-contained (they work from a phone file manager too). Internet is needed for fonts, 3D and Supabase.

## Deploy (free, ~1 minute)
- Netlify: drag this whole folder onto https://app.netlify.com/drop
- or Vercel / Cloudflare Pages: upload the folder (vercel.json / _redirects already included)
Then open  https://YOUR-SITE/admin  in Chrome.

## Admin login
Email: najimnajim75598@gmail.com — then Security tab -> change your password.

## What the dashboard has
Overview (visitor + message charts, device split, project status, profile completeness), Profile (photo upload with live preview),
Projects (add/edit/reorder/delete), Messages inbox (search, reply, delete), Security (password strength meter).

Data lives in your Supabase project `najimul-xmx-portfolio` (tables prefixed pf_, see supabase-applied.sql — already applied).
