Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030385Ab2CGTtr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 14:49:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46076 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030250Ab2CGTtm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 14:49:42 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 19/29] Disintegrate asm/system.h for OpenRISC
To: paul.gortmaker@windriver.com, hpa@zytor.com
Cc: torvalds@linux-foundation.org, sfr@canb.auug.org.au, mingo@redhat.com,
        arnd@arndb.de, dhowells@redhat.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Date: Wed, 07 Mar 2012 19:49:26 +0000
Message-ID: <20120307194925.15987.83054.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120307194548.15987.36073.stgit@warthog.procyon.org.uk>
References: <20120307194548.15987.36073.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disintegrate asm/system.h for OpenRISC.  Not compiled.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/openrisc/include/asm/system.h |   35 -----------------------------------
 1 files changed, 0 insertions(+), 35 deletions(-)
 delete mode 100644 arch/openrisc/include/asm/system.h

diff --git a/arch/openrisc/include/asm/system.h b/arch/openrisc/include/asm/system.h
deleted file mode 100644
index cf65888..0000000
--- a/arch/openrisc/include/asm/system.h
+++ /dev/null
@@ -1,35 +0,0 @@
-/*
- * OpenRISC Linux
- *
- * Linux architectural port borrowing liberally from similar works of
- * others.  All original copyrights apply as per the original source
- * declaration.
- *
- * OpenRISC implementation:
- * Copyright (C) 2003 Matjaz Breskvar <phoenix@bsemi.com>
- * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
- * et al.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#ifndef __ASM_OPENRISC_SYSTEM_H
-#define __ASM_OPENRISC_SYSTEM_H
-
-#ifdef __KERNEL__
-#ifndef __ASSEMBLY__
-
-#include <asm/spr.h>
-#include <asm-generic/system.h>
-
-/* We probably need this definition, but the generic system.h provides it
- * and it's not used on our arch anyway...
- */
-/*#define nop() __asm__ __volatile__ ("l.nop"::)*/
-
-#endif /* __ASSEMBLY__ */
-#endif /* __KERNEL__ */
-#endif /* __ASM_OPENRISC_SYSTEM_H */

