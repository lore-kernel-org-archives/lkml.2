Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165Ab2AVSQA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 13:16:00 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:36573 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751756Ab2AVSP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 13:15:59 -0500
MIME-Version: 1.0
Date: Sun, 22 Jan 2012 13:15:58 -0500
Message-ID: <CAMW5UfYGU+K0tet+z8g+fYS54jba57gaWW_C7r3VY9JcrDryRQ@mail.gmail.com>
Subject: [PATCH] drivers/usb/misc/sisusbvga/sisusb.c Add support for Triton
 See 2 Xtreme
From: Josh Coombs <josh.coombs@gmail.com>
To: thomas@winischhofer.net
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Thomas,

I've been playing with a Triton See 2 Xtreme SiS based USB VGA adapter
and had decent luck with it under your driver after adding it's device
ID.

--- drivers/usb/misc/sisusbvga/sisusb.c.orig	2012-01-22 13:01:07.000000000 -0500
+++ drivers/usb/misc/sisusbvga/sisusb.c	2012-01-22 13:01:26.000000000 -0500
@@ -3247,6 +3247,7 @@ static const struct usb_device_id sisusb
 	{ USB_DEVICE(0x0711, 0x0903) },
 	{ USB_DEVICE(0x0711, 0x0918) },
 	{ USB_DEVICE(0x0711, 0x0920) },
+        { USB_DEVICE(0x0711, 0x0950) },
 	{ USB_DEVICE(0x182d, 0x021c) },
 	{ USB_DEVICE(0x182d, 0x0269) },
 	{ }

I've been primarily using it on an ARMv5 system, and will try to test
on x86 soon.  I've used the patch on both 3.1-release and 3.2-release.
 I just verified 3.3-RC1 hasn't had any changes to the sisusb driver
and will be building a test kernel this afternoon.  Given it's just a
one line tweak, is this patch sufficient to go upstream, or would you
like some additional info from my setup first?

Signed-off-by: Joshua Coombs <josh.coombs@gmail.com>
