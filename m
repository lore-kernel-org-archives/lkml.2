Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188Ab0EJTLy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 15:11:54 -0400
Received: from penguin.host-ns.co.uk ([213.229.84.196]:20948 "EHLO
	penguin.host-ns.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755751Ab0EJTLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 15:11:50 -0400
Subject: wlan-ng: hfa384x_usb.c patch: Fix Whitespace issues
From: Adam Latham <adam.latham@unisontorbay.org.uk>
Reply-To: adam.latham@unisontorbay.org.uk
To: gregkh@suse.de, Andrew.Elwell@gmail.com, mithlesh@linsyssoft.com,
       svenne@krap.dk, jkosina@suse.cz
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 May 2010 20:11:26 +0100
Message-ID: <1273518686.2786.3.camel@ubuntu.ubuntu-domain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - penguin.host-ns.co.uk
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - unisontorbay.org.uk
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From bd66eecfcc4fa4c0340f55d73dd4ada3a5e0b00a Mon Sep 17 00:00:00 2001
From: Adam Latham <adam.latham@unisontorbay.org.uk>
Date: Mon, 10 May 2010 19:59:39 +0100
Subject: [PATCH] Staging: wlan-ng: fix whitespace errors in hfa384x_usb.c
 This is a patch to fix a number of whitespace issues in the hfa384x_usb.c
 file found by the checkpatch.pl tool

Signed-off-by: Adam Latham <adam.latham@unisontorbay.org.uk>
---
 drivers/staging/wlan-ng/hfa384x_usb.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wlan-ng/hfa384x_usb.c b/drivers/staging/wlan-ng/hfa384x_usb.c
index 5df56f0..562e7eb 100644
--- a/drivers/staging/wlan-ng/hfa384x_usb.c
+++ b/drivers/staging/wlan-ng/hfa384x_usb.c
@@ -62,7 +62,7 @@
 *
 * hfa384x_drvr_xxxconfig  An example of the drvr level abstraction. These
 *			functions are wrappers for the RID get/set
-*			sequence. They 	call copy_[to|from]_bap() and
+*			sequence. They call copy_[to|from]_bap() and
 *			cmd_access().	These functions operate on the
 *			RIDs and buffers without validation.  The caller
 *			is responsible for that.
@@ -1226,7 +1226,7 @@ int hfa384x_corereset(hfa384x_t *hw, int holdtime, int settletime, int genesis)
 *
 * Arguments:
 *	hw		device structure
-*	ctlx	 	CTLX ptr
+*	ctlx		CTLX ptr
 *	completor	functor object to decide what to
 *			do with the CTLX's result.
 *
@@ -2133,7 +2133,7 @@ exit_proc:
 *	0		success
 *	>0		f/w reported error - f/w status code
 *	<0		driver reported error
-*	-ENODATA 	length mismatch between argument and retrieved
+*	-ENODATA	length mismatch between argument and retrieved
 *			record.
 *
 * Side effects:

1.7.0.4



