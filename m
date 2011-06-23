Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933564Ab1FWSaA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:30:00 -0400
Received: from mail.windriver.com ([147.11.1.11]:63003 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932609Ab1FWRWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:22:15 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org,
        Arvid Ephraim Picciani <arvid.picciani@nokia.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 022/247] USB: cdc-acm: Adding second ACM channel support for Nokia N8
Date: Thu, 23 Jun 2011 13:17:45 -0400
Message-Id: <1308849690-14530-23-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arvid Ephraim Picciani <arvid.picciani@nokia.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 721d92fc6373dee15846216f9d178ec240ec0fd7 upstream.

This adds the N8 to the list of devices in cdc-acm, in order to get the
secondary ACM device exposed.

In the spirit of:
http://kerneltrap.org/mailarchive/linux-usb/2010/9/4/6264554

Signed-off-by: Arvid Ephraim Picciani <arvid.picciani@nokia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/class/cdc-acm.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index f1accc8..a45e6c4 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1613,6 +1613,7 @@ static const struct usb_device_id acm_ids[] = {
 	{ NOKIA_PCSUITE_ACM_INFO(0x0154), }, /* Nokia 5800 XpressMusic */
 	{ NOKIA_PCSUITE_ACM_INFO(0x04ce), }, /* Nokia E90 */
 	{ NOKIA_PCSUITE_ACM_INFO(0x01d4), }, /* Nokia E55 */
+	{ NOKIA_PCSUITE_ACM_INFO(0x0302), }, /* Nokia N8 */
 	{ SAMSUNG_PCSUITE_ACM_INFO(0x6651), }, /* Samsung GTi8510 (INNOV8) */
 
 	/* NOTE: non-Nokia COMM/ACM/0xff is likely MSFT RNDIS... NOT a modem! */
-- 
1.7.4.4

