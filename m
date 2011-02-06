Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab1BFVqb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 16:46:31 -0500
Received: from www.tglx.de ([62.245.132.106]:45941 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753556Ab1BFVqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 16:46:10 -0500
Message-Id: <20110206214535.061407843@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sun, 06 Feb 2011 21:45:55 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: David Howells <dhowells@redhat.com>
Subject: [patch 7/7] mn10300: Select GENERIC_HARDIRQS_NO_DEPRECATED
References: <20110206214441.438777646@linutronix.de>
Content-Disposition: inline; filename=mn10300-set-nodepr.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All chips converted.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/mn10300/Kconfig |    1 +
 1 file changed, 1 insertion(+)

Index: linux-next/arch/mn10300/Kconfig
===================================================================
--- linux-next.orig/arch/mn10300/Kconfig
+++ linux-next/arch/mn10300/Kconfig
@@ -2,6 +2,7 @@ config MN10300
 	def_bool y
 	select HAVE_OPROFILE
 	select GENERIC_HARDIRQS
+	select GENERIC_HARDIRQS_NO_DEPRECATED
 
 config AM33_2
 	def_bool n


