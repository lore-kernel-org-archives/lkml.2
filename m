Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758218Ab0JELqK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 07:46:10 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:47790 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751653Ab0JELqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 07:46:08 -0400
Date: Tue, 5 Oct 2010 13:44:33 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] x86/xen: remove duplicated include
Message-ID: <20101005134433.511e84f4@absol.kitzblitz>
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

Remove duplicated include.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 arch/x86/xen/enlighten.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 7d46c84..3396891 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -58,7 +58,6 @@
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 #include <asm/reboot.h>
-#include <asm/setup.h>
 #include <asm/stackprotector.h>
 #include <asm/hypervisor.h>
 
-- 
1.7.2.2
