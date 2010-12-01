Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921Ab0LAMYh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 07:24:37 -0500
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:39511 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751417Ab0LAMYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 07:24:36 -0500
Date: Wed, 1 Dec 2010 13:09:10 +0100
From: Nicolas Kaiser <nikai@nikai.net>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Documentation: ABI/stable: sysfs-driver-usb-usbtmc: fix
 typo
Message-ID: <20101201130910.7d32c3bc@absol.kitzblitz>
Organization: -
X-Face: "fF&[w2"Nws:JNH4'g|:gVhgGKLhj|X}}&w&V?]0=,7n`jy8D6e[Jh=7+ca|4~t5e[ItpL5
 N'y~Mvi-vJm`"1T5fi1^b!&EG]6nW~C!FN},=$G?^U2t~n[3;u\"5-|~H{-5]IQ2
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed typo.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 Documentation/ABI/stable/sysfs-driver-usb-usbtmc |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/ABI/stable/sysfs-driver-usb-usbtmc b/Documentation/ABI/stable/sysfs-driver-usb-usbtmc
index 9a75fb2..d40c193 100644
--- a/Documentation/ABI/stable/sysfs-driver-usb-usbtmc
+++ b/Documentation/ABI/stable/sysfs-driver-usb-usbtmc
@@ -55,7 +55,7 @@ What:		/sys/bus/usb/drivers/usbtmc/devices/*/auto_abort
 Date:		August 2008
 Contact:	Greg Kroah-Hartman <gregkh@suse.de>
 Description:
-		This file determines if the the transaction of the USB TMC
+		This file determines if the transaction of the USB TMC
 		device is to be automatically aborted if there is any error.
 		For more details about this, please see the document,
 		"Universal Serial Bus Test and Measurement Class Specification
-- 
1.7.2.2
