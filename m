Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492Ab0HKQeR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 12:34:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41408 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753046Ab0HKQeQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 12:34:16 -0400
Date: Wed, 11 Aug 2010 18:34:09 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jeremy Fitzhardinge <jeremy@xensource.com>,
        Chris Wright <chrisw@sous-sol.org>, Alok Kataria <akataria@vmware.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Cc: virtualization@lists.osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] paravirt: noreplace-paravirt is implemented for x86 and
 ia-64
Message-ID: <alpine.LNX.2.00.1008111832510.2702@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel-parameters.txt lists 'noreplace-paravirt' parameter as being
limited to X86-32, which is incorrect -- it's actually supported by
x86-32, x86-64 and ia-64.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 Documentation/kernel-parameters.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index d529b13..8ed3a77 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1777,7 +1777,7 @@ and is between 256 and 4096 characters. It is defined in the file
 	norandmaps	Don't use address space randomization.  Equivalent to
 			echo 0 > /proc/sys/kernel/randomize_va_space
 
-	noreplace-paravirt	[X86-32,PV_OPS] Don't patch paravirt_ops
+	noreplace-paravirt	[X86,IA-64,PV_OPS] Don't patch paravirt_ops
 
 	noreplace-smp	[X86-32,SMP] Don't replace SMP instructions
 			with UP alternatives
-- 
1.7.2.1

