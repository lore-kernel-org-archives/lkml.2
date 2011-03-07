Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137Ab1CGRsc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 12:48:32 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:52444 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169Ab1CGRsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 12:48:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type;
        b=DkKO9Sa7XsvfpGAhXo4UB/AxYrIcAwlPkrkAchyUyfYBt9U9p1Kz3upLbH118nfsPg
         mS782HffilrZnpAUAfrUKnrtBHqdxtuUGAFgXTz3A9Qzpmbz2w8OWaeaIz54pKXAyerQ
         E3BHswS7ButYEMeHDGJ0QNFEzyWjZFzSmKPns=
Message-ID: <4D751A68.6090305@users.sourceforge.net>
Date: Mon, 07 Mar 2011 19:48:24 +0200
From: Alberto Mardegan <mardy@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Lightning/1.0b2 Thunderbird/3.1.8
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] Platform: Samsung R410P backlight driver
References: <4D750057.6040104@users.sourceforge.net> <20110307161041.GA8623@suse.de>
In-Reply-To: <20110307161041.GA8623@suse.de>
Content-Type: multipart/mixed;
 boundary="------------060402070506010901020203"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060402070506010901020203
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Here's a trivial patch which adds support to the backlight device found
in Samsung R410 Plus laptops.

Signed-off-by: Alberto Mardegan <mardy@users.sourceforge.net>


-- 
http://blog.mardy.it <- geek in un lingua international!

--------------060402070506010901020203
Content-Type: text/x-patch;
 name="samsung-laptop.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="samsung-laptop.patch"

diff --git a/drivers/staging/samsung-laptop/samsung-laptop.c b/drivers/staging/samsung-laptop/samsung-laptop.c
index e0b390d..1813d5b 100644
--- a/drivers/staging/samsung-laptop/samsung-laptop.c
+++ b/drivers/staging/samsung-laptop/samsung-laptop.c
@@ -571,6 +571,16 @@ static struct dmi_system_id __initdata samsung_dmi_table[] = {
 		.callback = dmi_check_cb,
 	},
 	{
+		.ident = "R410 Plus",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR,
+					"SAMSUNG ELECTRONICS CO., LTD."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "R410P"),
+			DMI_MATCH(DMI_BOARD_NAME, "R460"),
+		},
+		.callback = dmi_check_cb,
+	},
+	{
 		.ident = "R518",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR,

--------------060402070506010901020203--
