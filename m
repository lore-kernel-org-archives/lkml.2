Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691Ab2IRVm5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 17:42:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38086 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755142Ab2IRVmz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 17:42:55 -0400
Date: Tue, 18 Sep 2012 23:42:46 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Andi Kleen <ak@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] [RFC] memory.txt: remove stray information
Message-ID: <alpine.LNX.2.00.1209182336280.31149@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi removed some outedated documentation from Documentation/memory.txt 
back in 2009 by 3b2b9a875dd ("Documentation/memory.txt: remove some very 
outdated recommendations"), but the resulting document is not in a nice 
shape either.

It seems to me like we are not losing anything by completely removing the
file now.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 Documentation/memory.txt |   33 ---------------------------------
 1 files changed, 0 insertions(+), 33 deletions(-)
 delete mode 100644 Documentation/memory.txt

diff --git a/Documentation/memory.txt b/Documentation/memory.txt
deleted file mode 100644
index 802efe5..0000000
--- a/Documentation/memory.txt
+++ /dev/null
@@ -1,33 +0,0 @@
-There are several classic problems related to memory on Linux
-systems.
-
-	1) There are some motherboards that will not cache above
-	   a certain quantity of memory.  If you have one of these
-	   motherboards, your system will be SLOWER, not faster
-	   as you add more memory.  Consider exchanging your 
-           motherboard.
-
-All of these problems can be addressed with the "mem=XXXM" boot option
-(where XXX is the size of RAM to use in megabytes).  
-It can also tell Linux to use less memory than is actually installed.
-If you use "mem=" on a machine with PCI, consider using "memmap=" to avoid
-physical address space collisions.
-
-See the documentation of your boot loader (LILO, grub, loadlin, etc.) about
-how to pass options to the kernel.
-
-There are other memory problems which Linux cannot deal with.  Random
-corruption of memory is usually a sign of serious hardware trouble.
-Try:
-
-	* Reducing memory settings in the BIOS to the most conservative 
-          timings.
-
-	* Adding a cooling fan.
-
-	* Not overclocking your CPU.
-
-	* Having the memory tested in a memory tester or exchanged
-	  with the vendor. Consider testing it with memtest86 yourself.
-	
-	* Exchanging your CPU, cache, or motherboard for one that works.

-- 
Jiri Kosina
SUSE Labs
