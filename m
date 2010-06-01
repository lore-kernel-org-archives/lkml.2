Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040Ab0FACb7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 22:31:59 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:50526 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003Ab0FACb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 22:31:58 -0400
Message-ID: <4C0470BE.6040709@oracle.com>
Date: Mon, 31 May 2010 19:30:22 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: linux-kernel@vger.kernel.org, "arjan@infradead.org" <arjan@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] Documentation/timers/hpet_example.c: only build on X64
References: <20100528113514.GA3686@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20100528113514.GA3686@osiris.boeblingen.de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090207.4C047103.000D:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

We should only build hpet_example on X64, where it is
implemented.  It can cause build errors on other arch-es.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Reported-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Arjan van de Ven <arjan@infradead.org>
---
 Documentation/timers/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- lnx-2635-rc1.orig/Documentation/timers/Makefile
+++ lnx-2635-rc1/Documentation/timers/Makefile
@@ -2,7 +2,7 @@
 obj- := dummy.o
 
 # List of programs to build
-hostprogs-y := hpet_example
+hostprogs-$(CONFIG_X86) := hpet_example
 
 # Tell kbuild to always build the programs
 always := $(hostprogs-y)
