Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934366Ab1FWSdm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:33:42 -0400
Received: from mail.windriver.com ([147.11.1.11]:62702 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759757Ab1FWRV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:21:57 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Craig Shelley <craig@microtron.org.uk>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 007/247] USB: CP210x Add two device IDs
Date: Thu, 23 Jun 2011 13:17:30 -0400
Message-Id: <1308849690-14530-8-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Craig Shelley <craig@microtron.org.uk>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit faea63f7ccfddfb8fc19798799fcd38c58415172 upstream.

Device Ids added for IRZ Automation Teleport SG-10 GSM/GPRS Modem and
DekTec DTA Plus VHF/UHF Booster/Attenuator.

Signed-off-by: Craig Shelley <craig@microtron.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/serial/cp210x.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index 8f46285..bc1c9c2 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -110,7 +110,9 @@ static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x10C4, 0x8341) }, /* Siemens MC35PU GPRS Modem */
 	{ USB_DEVICE(0x10C4, 0x8382) }, /* Cygnal Integrated Products, Inc. */
 	{ USB_DEVICE(0x10C4, 0x83A8) }, /* Amber Wireless AMB2560 */
+	{ USB_DEVICE(0x10C4, 0x83D8) }, /* DekTec DTA Plus VHF/UHF Booster/Attenuator */
 	{ USB_DEVICE(0x10C4, 0x8411) }, /* Kyocera GPS Module */
+	{ USB_DEVICE(0x10C4, 0x8418) }, /* IRZ Automation Teleport SG-10 GSM/GPRS Modem */
 	{ USB_DEVICE(0x10C4, 0x846E) }, /* BEI USB Sensor Interface (VCP) */
 	{ USB_DEVICE(0x10C4, 0x8477) }, /* Balluff RFID */
 	{ USB_DEVICE(0x10C4, 0xEA60) }, /* Silicon Labs factory default */
-- 
1.7.4.4

