Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab1LMLgp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 06:36:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:56970 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab1LMLgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 06:36:44 -0500
Message-ID: <4EE738CA.8030409@canonical.com>
Date: Tue, 13 Dec 2011 11:36:42 +0000
From: James Hunt <james.hunt@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Upstart Devel List <upstart-devel@lists.ubuntu.com>,
        linux-kernel@vger.kernel.org
Subject: Upstart 1.4 "Let them speak" released
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Summary of changes:

* Improved console setting.
* New "log" argument to console stanza allowing a system jobs
  stdout/stderr to be captured to a file. New options added to
  support this feature: '--default-console', '--logdir',
  '--no-log'. This feature only currently applies to system jobs:
  user jobs which specify "console log" will be treated as if they
  had specified "console none".
* New "setuid" and "setgid" stanzas to allow system jobs to be run
  under the specified uid/gid corresponding to the given name/group.
* Improvements to upstart-udev-bridge to handle problematic hardware
  (such as some batteries) which pass non-printable bytes to userspace.

Download it from launchpad: https://launchpad.net/upstart

Kind regards,

James.
- --
James Hunt
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJO5zi9AAoJEJ1Q4UTmNXMnJoAQAJBZC+SyNuvCeVUplVhdKUwy
Rrhywx7ul2rPx/ZoyXI/SgVlzRJoKDQGYmgwtbunh2bPn8HdpzkB4Oo0//jNlT6K
6yPVUJ3LOd/JCW3XNOwZqsDDO9eMHKP39yLBLXnjEDglZu2FG7bcdzisDXOXxYF8
xR3Y+Z+eM0YuJuOLnF4s4MByiM8jgJHDQ/N479OkRPnu/Qb9/E46qurp+fq3EokU
uGTn+eCa0bnkbHYLo0d4hE4KCvkXWKtkqXBpZoZUsWtPXKfem3pPPz8nCW/J3YvS
4hSaY6GsBRxz4gmiIDF+nG/zDAJZb4MCQIYFiihBzcRsF5NSKYiac9vUVNX60kdC
89WkdbRDdEQzvXeF1R7bTFtv+HraV1HP8PHh2jExmiliUknEqZVwyvtSWec6EuNj
9vp8lQ/I70N53l9gUi7e+vssYlNlYpTUFkKdfLvmTwoSduJs9ZfldubG/Bnxbhy2
DpzoPvb/Z3WcCdAeDkAgxdMmgsGp0E28SKJZ06OWXAs5yOupFO9cXebOIxEUr57P
WUupmzNO/yz88nsaQ8Cu+823aFIK4xKkNURy+Y7Q63JM8FxXCTBEnujJzxm1zfdE
vOO7SkOLpDr3qj0F0JNck6GDt4RkiunBPy5gO7XqxG9ApkI5YnN3LtvskCv9erhx
QHb7A7D/2tFY1OCB4O0g
=cf3s
-----END PGP SIGNATURE-----
