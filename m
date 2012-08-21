Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246Ab2HUKZu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 06:25:50 -0400
Received: from skyrme.org ([193.175.80.135]:33389 "EHLO skyrme.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754436Ab2HUKZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 06:25:48 -0400
X-Greylist: delayed 1895 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Aug 2012 06:25:48 EDT
Date: 21 Aug 2012 09:54:09 +0000
Message-Id: <1345542849-13621-1-git-send-email-oskar@scara.com>
From: "Oskar Schirmer" <oskar@scara.com>
To: trivial@kernel.org
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        "Oskar Schirmer" <oskar@scara.com>,
        "John Anthony Kazos Jr" <jakj@j-a-k-j.com>,
        "Rob Landley" <rob@landley.net>
Subject: [PATCH] Documentation: fix broken utf8 encoding
X-Mailer: git-send-email 1.6.0.3
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
index 92341b8..0b4b63e 100644
--- a/Documentation/power/swsusp.txt
+++ b/Documentation/power/swsusp.txt
@@ -53,7 +53,7 @@ before suspend (it is limited to 500 MB by default).
 
 Article about goals and implementation of Software Suspend for Linux
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-Author: Gábor Kuti
+Author: Gábor Kuti
 Last revised: 2003-10-20 by Pavel Machek
 
 Idea and goals to achieve
-- 
1.7.9.5

