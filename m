Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932200Ab0KMS57 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 13:57:59 -0500
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:50102 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755994Ab0KMS5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 13:57:55 -0500
Date: Sat, 13 Nov 2010 19:43:27 +0100
From: Nicolas Kaiser <nikai@nikai.net>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        Frank Mori Hess <fmhess@users.sourceforge.net>,
        devel@driverdev.osuosl.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] staging: comedi: fix typo in error message
Message-ID: <20101113194327.38142df9@absol.kitzblitz>
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

Fix typo in error message of dux commands allocation.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 drivers/staging/comedi/drivers/usbdux.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/comedi/drivers/usbdux.c b/drivers/staging/comedi/drivers/usbdux.c
index 1f177a6..aca4d14 100644
--- a/drivers/staging/comedi/drivers/usbdux.c
+++ b/drivers/staging/comedi/drivers/usbdux.c
@@ -2398,7 +2398,7 @@ static int usbduxsub_probe(struct usb_interface *uinterf,
 	usbduxsub[index].dux_commands = kzalloc(SIZEOFDUXBUFFER, GFP_KERNEL);
 	if (!usbduxsub[index].dux_commands) {
 		dev_err(dev, "comedi_: usbdux: "
-			"error alloc space for dac commands\n");
+			"error alloc space for dux commands\n");
 		tidy_up(&(usbduxsub[index]));
 		up(&start_stop_sem);
 		return -ENOMEM;
-- 
1.7.2.2
