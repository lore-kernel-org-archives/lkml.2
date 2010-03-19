Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143Ab0CSL6T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 07:58:19 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:36870 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171Ab0CSL6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 07:58:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Z+q4jyaGn6aD/50hpYGOdZE0eCO6fQhZvt7Pp4YwAtL1IovY+ftt11jei0OKUf1GU4
         6o7CvTwwnVzqfHIgIrE1y8eNTzJ0gdsTceBk2TVhCE2vsFUTvdvz6VuVBy/Y6azIHC6F
         lE6CeusCGG0B25ujl8P/TQoZng9/xgoPMzwhE=
From: candyguitar@googlemail.com
To: gregkh@suse.de, jmm@debian.org, mithlesh@linsyssoft.com, svenne@krap.dk
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Patrick Rooney <candyguitar@googlemail.com>
Subject: [PATCH 1/2] Staging: wlan-ng: Fixed 80-character line coding style issues in p80211req.c
Date: Fri, 19 Mar 2010 11:57:38 +0000
Message-Id: <1268999858-17323-1-git-send-email-candyguitar@googlemail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Candyguitar <candyguitar@candyguitar-laptop.(none)>

This is a patch for p80211req.c. An 'if' statement that spanned 80
characters has been split onto 2 lines and one of the tabs preceding
a comment has been removed.

Signed-off-by: Patrick Rooney <candyguitar@googlemail.com>
---
 drivers/staging/wlan-ng/p80211req.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wlan-ng/p80211req.c b/drivers/staging/wlan-ng/p80211req.c
index c2e95f1..74e2fe4 100644
--- a/drivers/staging/wlan-ng/p80211req.c
+++ b/drivers/staging/wlan-ng/p80211req.c
@@ -108,7 +108,8 @@ int p80211req_dorequest(wlandevice_t *wlandev, u8 *msgbuf)
 	}
 
 	/* Check Permissions */
-	if (!capable(CAP_NET_ADMIN) && (msg->msgcode != DIDmsg_dot11req_mibget)) {
+	if (!capable(CAP_NET_ADMIN) &&
+	(msg->msgcode != DIDmsg_dot11req_mibget)) {
 		printk(KERN_ERR
 		       "%s: only dot11req_mibget allowed for non-root.\n",
 		       wlandev->name);
@@ -129,7 +130,7 @@ int p80211req_dorequest(wlandevice_t *wlandev, u8 *msgbuf)
 		wlandev->mlmerequest(wlandev, msg);
 
 	clear_bit(1, &(wlandev->request_pending));
-	return result;		/* if result==0, msg->status still may contain an err */
+	return result;	/* if result==0, msg->status still may contain an err */
 }
 
 /*----------------------------------------------------------------
-- 
1.6.3.3

