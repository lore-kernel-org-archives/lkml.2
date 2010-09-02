Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757907Ab0IBVVj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 17:21:39 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:41439 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932187Ab0IBVJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 17:09:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=VttQ42wX2iHVYF/4JINxRSEqmbq8WKssjd5fY+TvK8zr+Jn4NY7p17X4WEfMrkS9Gq
         2OsiHh043USTDHb0D806atWS4Odp+fE7+0K60TQR+1SLC6VlBAAgYZRp5jLDG03iEEtB
         8rQMsY3FqT17ZfNMkv9RmckHrxWFeLo3zKYxg=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, jkosina@suse.cz,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 35/91] arch/m68k/q40/README Update broken web addresses in the arch directory.
Date: Thu,  2 Sep 2010 14:08:56 -0700
Message-Id: <1283461746-7905-5-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1283461746-7905-1-git-send-email-justinmattock@gmail.com>
References: <1283461746-7905-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below patch updates a broken web address that is no longer
working due to company buyout, and/or change of location.
(Please have a look through, and let me know if any of them
need to be changed, and I'll resend an updated patch).

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 arch/m68k/q40/README |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/m68k/q40/README b/arch/m68k/q40/README
index 6bdbf48..0d26762 100644
--- a/arch/m68k/q40/README
+++ b/arch/m68k/q40/README
@@ -1,10 +1,10 @@
 Linux for the Q40
 =================
 
-You may try http://www.geocities.com/SiliconValley/Bay/2602/ for
-some up to date information. Booter and other tools will be also
-available from this place or ftp.uni-erlangen.de/linux/680x0/q40/
-and mirrors.
+You may try http://web.archive.org/web/*/http://geocities.com/
+SiliconValley/Bay/2602/ for some up to date information. Booter
+and other tools will be also available from this place or 
+http://www.linux-m68k.org/mail.html and mirrors.
 
 Hints to documentation usually refer to the linux source tree in
 /usr/src/linux/Documentation unless URL given.
-- 
1.7.2.1

