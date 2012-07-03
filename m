Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932281Ab2GCJ1g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 05:27:36 -0400
Received: from skyrme.org ([193.175.80.135]:44123 "EHLO skyrme.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755198Ab2GCJ1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 05:27:33 -0400
Date: 3 Jul 2012 09:27:25 +0000
Message-Id: <1341307645-15135-2-git-send-email-oskar@scara.com>
From: "Oskar Schirmer" <oskar@scara.com>
To: "Rob Landley" <rob@landley.net>
Cc: linux-kernel@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>,
        "Oskar Schirmer" <oskar@scara.com>,
        "John Anthony Kazos Jr" <jakj@j-a-k-j.com>,
        "Rob Landley" <rob@landley.net>
Subject: [PATCH 2/2] Documentation: fix broken utf8 encoding
X-Mailer: git-send-email 1.6.0.3
In-Reply-To: <1341307645-15135-1-git-send-email-oskar@scara.com>
References: <1341307645-15135-1-git-send-email-oskar@scara.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

conversion to utf8 left some extra control character here,
remove it.

Signed-off-by: Oskar Schirmer <oskar@scara.com>
Cc: John Anthony Kazos Jr <jakj@j-a-k-j.com>
Cc: Rob Landley <rob@landley.net>
---
 Documentation/power/swsusp.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/power/swsusp.txt b/Documentation/power/swsusp.txt
index ac190cf..3f9610b 100644
--- a/Documentation/power/swsusp.txt
+++ b/Documentation/power/swsusp.txt
@@ -48,7 +48,7 @@ before suspend (it is limited to 500 MB by default).
 
 Article about goals and implementation of Software Suspend for Linux
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-Author: Gábor Kuti
+Author: Gábor Kuti
 Last revised: 2003-10-20 by Pavel Machek
 
 Idea and goals to achieve
-- 
1.7.9.5

