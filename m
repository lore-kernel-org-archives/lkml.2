Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691Ab0EBHdj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 May 2010 03:33:39 -0400
Received: from smtprelay-b12.telenor.se ([62.127.194.21]:59120 "EHLO
	smtprelay-b12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754Ab0EBHdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 May 2010 03:33:38 -0400
X-SENDER-IP: [83.226.250.226]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ai8+AMbH3EtT4vriPGdsb2JhbACBN4RCgXCVTgEBAQE1uHKFEgQ
X-IronPort-AV: E=Sophos;i="4.52,311,1270418400"; 
   d="scan'208";a="69704705"
Message-ID: <4BDD2AC6.8010900@coyote.org>
Date: Sun, 02 May 2010 09:33:26 +0200
From: Lars Lindley <lindley@coyote.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100428 Thunderbird/3.0.4
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: gregkh@suse.de, pavel@ucw.cz, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: Staging: winbond: Renamed README to TODO and corrected Pavel's
 mail
References: <1268431099-18367-1-git-send-email-lindley@coyote.org> <20100427203816.GB22461@kroah.com>
In-Reply-To: <20100427203816.GB22461@kroah.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-04-27 22:38, Greg KH wrote:
> I need a "Signed-off-by:" line in order to be able to apply this.  Care
> to resend it with it?
> 
> thanks,
> 
> greg k-h
> 
> 
Ok here it comes.




[PATCH] staging: winbond: Renamed README to TODO and corrected Pavel's mail

Signed-off-by: Lars Lindley <lindley@coyote.org>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 drivers/staging/winbond/README |   11 -----------
 drivers/staging/winbond/TODO   |   11 +++++++++++
 2 files changed, 11 insertions(+), 11 deletions(-)
 delete mode 100644 drivers/staging/winbond/README
 create mode 100644 drivers/staging/winbond/TODO

diff --git a/drivers/staging/winbond/README b/drivers/staging/winbond/README
deleted file mode 100644
index cb944e4..0000000
--- a/drivers/staging/winbond/README
+++ /dev/null
@@ -1,11 +0,0 @@
-TODO:
-	- sparse cleanups
-	- checkpatch cleanups
-	- kerneldoc cleanups
-	- remove typedefs
-	- remove unused ioctls
-	- use cfg80211 for regulatory stuff
-	- fix 4k stack problems
-
-Please send patches to Greg Kroah-Hartman <greg@kroah.com> and
-Pavel Machek <pavel@suse.cz>
diff --git a/drivers/staging/winbond/TODO b/drivers/staging/winbond/TODO
new file mode 100644
index 0000000..f4fb3f3
--- /dev/null
+++ b/drivers/staging/winbond/TODO
@@ -0,0 +1,11 @@
+TODO:
+	- sparse cleanups
+	- checkpatch cleanups
+	- kerneldoc cleanups
+	- remove typedefs
+	- remove unused ioctls
+	- use cfg80211 for regulatory stuff
+	- fix 4k stack problems
+
+Please send patches to Greg Kroah-Hartman <greg@kroah.com> and
+Pavel Machek <pavel@ucw.cz>
-- 
1.7.1
