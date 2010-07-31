Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060Ab0GaLVH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 07:21:07 -0400
Received: from katalix.com ([82.103.140.233]:43932 "EHLO mail.katalix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753362Ab0GaLVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 07:21:05 -0400
X-Greylist: delayed 542 seconds by postgrey-1.27 at vger.kernel.org; Sat, 31 Jul 2010 07:21:05 EDT
Date: Sat, 31 Jul 2010 12:15:43 +0100
From: James Chapman <james@bert.katalix.com>
Message-Id: <201007311115.o6VBFhR7008492@bert.katalix.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.35-rc6] l2tp: fix export of header file for userspace
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The header file l2tp.h should be exported to the installed
include/linux/ tree for userspace programs.

This patch fixes compilation errors in L2TP userspace apps which want
to use the new L2TP support introduced in 2.6.35.

Signed-off-by: James Chapman <jchapman@katalix.com>

Index: linux-2.6.35-rc6/include/linux/Kbuild
===================================================================
--- linux-2.6.35-rc6.orig/include/linux/Kbuild	2010-07-31 11:37:46.000000000 +0100
+++ linux-2.6.35-rc6/include/linux/Kbuild	2010-07-31 11:38:08.000000000 +0100
@@ -276,6 +276,7 @@
 		  $(srctree)/include/asm-$(SRCARCH)/kvm_para.h),)
 unifdef-y += kvm_para.h
 endif
+unifdef-y += l2tp.h
 unifdef-y += llc.h
 unifdef-y += loop.h
 unifdef-y += lp.h
