Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758792Ab0J1Nq4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 09:46:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:34800 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755459Ab0J1Nqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 09:46:54 -0400
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=8-x9nQSR450A:10 a=kj9zAlcOel0A:10 a=mpMdnlmFKti1S5SNY1DT+A==:17 a=yQdBAQUQAAAA:8 a=CjxXgO3LAAAA:8 a=VwQbUJbxAAAA:8 a=Z44L6zz-h1PFREQNEwkA:9 a=nl1kGc4b4FnD-d2isY0SR_JvmZgA:4 a=CjuIK1q_8ugA:10 a=IcxpeKGZWnEA:10 a=rC2wZJ5BpNYA:10 a=LI9Vle30uBYA:10 a=mpMdnlmFKti1S5SNY1DT+A==:117
X-Cloudmark-Score: 0
X-Originating-IP: 65.28.92.85
Date: Thu, 28 Oct 2010 08:47:13 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: crogonint@yahoo.com, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rt2870: Add new USB ID for Belkin F6D4050 v1
Message-ID: <4cc97ee1.wgYIjaudblVVNZRG%Larry.Finger@lwfinger.net>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add new USB ID for FT2870 for Belkin F6D4050 v1

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Reported- and Tested-by: James Long <crogonint@yahoo.com>
Cc: Stable <stable@kernel.org>
---

Index: linux-2.6/drivers/staging/rt2860/usb_main_dev.c
===================================================================
--- linux-2.6.orig/drivers/staging/rt2860/usb_main_dev.c
+++ linux-2.6/drivers/staging/rt2860/usb_main_dev.c
@@ -65,6 +65,7 @@ struct usb_device_id rtusb_usb_id[] = {
 	{USB_DEVICE(0x14B2, 0x3C07)},	/* AL */
 	{USB_DEVICE(0x050D, 0x8053)},	/* Belkin */
 	{USB_DEVICE(0x050D, 0x825B)},	/* Belkin */
+	{USB_DEVICE(0x050D, 0x935A)},	/* Belkin F6D4050 v1 */
 	{USB_DEVICE(0x050D, 0x935B)},	/* Belkin F6D4050 v2 */
 	{USB_DEVICE(0x14B2, 0x3C23)},	/* Airlink */
 	{USB_DEVICE(0x14B2, 0x3C27)},	/* Airlink */
