Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab1BFVp5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 16:45:57 -0500
Received: from www.tglx.de ([62.245.132.106]:45926 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752724Ab1BFVp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 16:45:56 -0500
Message-Id: <20110206214534.467325062@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sun, 06 Feb 2011 21:45:42 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: David Howells <dhowells@redhat.com>
Subject: [patch 1/7] mn10300: Remove stale irq_chip.end - V2
References: <20110206214441.438777646@linutronix.de>
Content-Disposition: inline; filename=mn10300-remove-stale-irq_chip-end.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

irq_chip.end got obsolete with the remnoval of __do_IRQ().

Might compiles this time, if i had a compiler ...

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/mn10300/kernel/mn10300-serial.c |    1 -
 1 file changed, 1 deletion(-)

Index: linux-next/arch/mn10300/kernel/mn10300-serial.c
===================================================================
--- linux-next.orig/arch/mn10300/kernel/mn10300-serial.c
+++ linux-next/arch/mn10300/kernel/mn10300-serial.c
@@ -394,7 +394,6 @@ static struct irq_chip mn10300_serial_pi
 	.mask		= mn10300_serial_mask_ack,
 	.mask_ack	= mn10300_serial_mask_ack,
 	.unmask		= mn10300_serial_nop,
-	.end		= mn10300_serial_nop,
 };
 
 


