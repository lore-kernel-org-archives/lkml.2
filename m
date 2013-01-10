Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409Ab3AJMHy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 07:07:54 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:48069 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754011Ab3AJMHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 07:07:52 -0500
From: Thomas Waldecker <thomas.waldecker@gmail.com>
To: benh@kernel.crashing.org
Cc: paulus@samba.org, rob@landley.net, linuxppc-dev@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Waldecker <thomas.waldecker@gmail.com>
Subject: [PATCH] PowerPC documentation: fixed path to the powerpc directory
Date: Thu, 10 Jan 2013 13:07:12 +0100
Message-Id: <1357819632-30814-1-git-send-email-thomas.waldecker@gmail.com>
X-Mailer: git-send-email 1.8.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ppc -> powerpc

Signed-off-by: Thomas Waldecker <thomas.waldecker@gmail.com>
---
 Documentation/powerpc/cpu_features.txt | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/powerpc/cpu_features.txt b/Documentation/powerpc/cpu_features.txt
index ffa4183..ae09df8 100644
--- a/Documentation/powerpc/cpu_features.txt
+++ b/Documentation/powerpc/cpu_features.txt
@@ -11,10 +11,10 @@ split instruction and data caches, and if the CPU supports the DOZE and NAP
 sleep modes.
 
 Detection of the feature set is simple. A list of processors can be found in
-arch/ppc/kernel/cputable.c. The PVR register is masked and compared with each
-value in the list. If a match is found, the cpu_features of cur_cpu_spec is
-assigned to the feature bitmask for this processor and a __setup_cpu function
-is called.
+arch/powerpc/kernel/cputable.c. The PVR register is masked and compared with
+each value in the list. If a match is found, the cpu_features of cur_cpu_spec
+is assigned to the feature bitmask for this processor and a __setup_cpu
+function is called.
 
 C code may test 'cur_cpu_spec[smp_processor_id()]->cpu_features' for a
 particular feature bit. This is done in quite a few places, for example
@@ -51,6 +51,6 @@ should be used in the majority of cases.
 
 The END_FTR_SECTION macros are implemented by storing information about this
 code in the '__ftr_fixup' ELF section. When do_cpu_ftr_fixups
-(arch/ppc/kernel/misc.S) is invoked, it will iterate over the records in
+(arch/powerpc/kernel/misc.S) is invoked, it will iterate over the records in
 __ftr_fixup, and if the required feature is not present it will loop writing
 nop's from each BEGIN_FTR_SECTION to END_FTR_SECTION.
-- 
1.8.0.2

