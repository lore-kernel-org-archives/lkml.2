Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071Ab0DMSvS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 14:51:18 -0400
Received: from smtp816.mail.ird.yahoo.com ([77.238.189.16]:43170 "HELO
	smtp816.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751440Ab0DMSvQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 14:51:16 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=btinternet.com;
  h=DKIM-Signature:Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:To:Subject:Cc:From:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=g2HmAt3jFLAwg5+uw41sv9fRkX6lflbT3lach5luPuXvDwF69I3sie+mq5lxaATjOAkMO3/uJ/MlpidCrs8LpA+ur4/rtOT+hNZXJJ2PYHrbyOAaTwbKo9IhWasPA7oS/AcQC7b8dBUa2exU7fj8qgnOi5u/poie6fCf1RTmBdY=  ;
X-Yahoo-SMTP: k5SysT6swBB9P.tkS3lzIbg6PUzaCV7jCcJpLj9TyF3meik1xcwV.g--
X-YMail-OSG: buQAYNIVM1lws619UmOmI1lLKiTsDUm.tKa3mt8NFfL570fCDd1BTvPiiBhxqTdaSvO0i9y5iuxuxFJoZFnPKxiROyik5Cjby0ZD0JOXPp5tS_QCQ74mNVWYA0zZOAijcu2a2sSSVPjV2ZzQahovzm2s1kzaf8ESy5vVLQEzL5YQ7gMomV6DZAoJmMIx12g1CqoT5CgB8Ra3BHYp4tKDJ2woIqZCL1I4CBrhsS1bImwvUvKCcu7PaajnL2kgbyrrbOThf8n3pQGRMrMl3bY.
X-Yahoo-Newman-Property: ymail-3
To: "Greg Kroah-Hartman" <gregkh@suse.de>, Andre Haupt <andre@bitwigglers.org>,
       Andi Kleen <ak@linux.intel.com>, Peter Huewe <peterhuewe@gmx.de>,
       "Kevin A. Granade" <kevin.granade@gmail.com>
Subject: [PATCH] Staging: asus_oled: fix spaces coding style in asus_oled.c
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
From: Laura Parkes <laura_parkes@btinternet.com>
Date: Tue, 13 Apr 2010 19:44:37 +0100
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201004131944.37793.laura_parkes@btinternet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From ada5a2f3c991cbbf8f6fbd97d72718c9bb806580 Mon Sep 17 00:00:00 2001
From: Laura Parkes <laura_parkes@btinternet.com>
Date: Sat, 20 Mar 2010 17:16:19 +0000
Subject: [PATCH] Staging: asus_oled: fix spaces coding style in asus_oled.c
 This is a patch to the asus_oled.c file that fixes a spaces
 warning found by checkpatch.pl tool.
 Signed-off-by: Laura Parkes <laura_parkes@btinternet.com>

---
 drivers/staging/asus_oled/asus_oled.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/asus_oled/asus_oled.c b/drivers/staging/asus_oled/asus_oled.c
index 7ebecc9..9e7e677 100644
--- a/drivers/staging/asus_oled/asus_oled.c
+++ b/drivers/staging/asus_oled/asus_oled.c
@@ -771,7 +771,7 @@ static struct usb_driver oled_driver = {
 };
 
 static CLASS_ATTR_STRING(version, S_IRUGO,
-		 	ASUS_OLED_UNDERSCORE_NAME " " ASUS_OLED_VERSION);
+	ASUS_OLED_UNDERSCORE_NAME " " ASUS_OLED_VERSION);
 
 static int __init asus_oled_init(void)
 {
-- 
1.6.3.3

