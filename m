Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758562Ab2GLAqP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 20:46:15 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62902 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756049Ab2GLApD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 20:45:03 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: Richard Fontana <fontana2012@gmail.com>
Cc: "Bradley M. Kuhn" <bkuhn@ebb.org>, linux-kernel@vger.kernel.org,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 4/4] copyleft-next: embrace the Signed-off-by practice
Date: Wed, 11 Jul 2012 17:44:49 -0700
Message-Id: <1342053889-32066-5-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 1.7.10.rc1.22.gf5241
In-Reply-To: <1342053889-32066-1-git-send-email-mcgrof@do-not-panic.com>
References: <1342053889-32066-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

The idea is taken from Linus Torvald's subsurface
project [0] README file. The Signed-off-by is widely
used in public projects and we stand to gain to make
its usage more prevalent. The meaning of the
Signed-off-by is borrowed from the Linux kernel's.

[0] git://github.com/torvalds/subsurface.git

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 CONTRIBUTING |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/CONTRIBUTING b/CONTRIBUTING
index 8f214b1..966366c 100644
--- a/CONTRIBUTING
+++ b/CONTRIBUTING
@@ -5,6 +5,36 @@ All original contributions to copyleft-next are dedicated to the
 public domain to the maximum extent permitted by applicable law,
 pursuant to CC0. See CC0 for further details.
 
+Please either send me signed-off patches or a pull request with
+signed-off commits.  If you don't sign off on them, I will not accept
+them. This means adding a line that says "Signed-off-by: Name <email>"
+at the end of each commit, indicating that you wrote the code and have
+the right to pass it on as an open source patch.
+
+See: http://gerrit.googlecode.com/svn/documentation/2.0/user-signedoffby.html
+
+Also, please write good git commit messages.  A good commit message
+looks like this:
+
+	Header line: explaining the commit in one line
+
+	Body of commit message is a few lines of text, explaining things
+	in more detail, possibly giving some background about the issue
+	being fixed, etc etc.
+
+	The body of the commit message can be several paragraphs, and
+	please do proper word-wrap and keep columns shorter than about
+	74 characters or so. That way "git log" will show things
+	nicely even when it's indented.
+
+	Reported-by: whoever-reported-it
+	Signed-off-by: Your Name <youremail@yourhost.com>
+
+where that header line really should be meaningful, and really should be
+just one line.  That header line is what is shown by tools like gitk and
+shortlog, and should summarize the change in one readable line of text,
+independently of the longer explanation.
+
 Contributions from individual free/libre/open source software project
 participants, regardless of their views on copyleft, and regardless of
 their opinions on existing licenses such as the GNU GPLv2 and its
-- 
1.7.10.rc1.22.gf5241

