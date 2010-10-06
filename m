Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758636Ab0JFM0y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 08:26:54 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:34241 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755615Ab0JFM0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 08:26:53 -0400
Date: Wed, 6 Oct 2010 14:23:22 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Joerg Roedel <joerg.roedel@amd.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] kvm: fix typo in copyright notice
Message-ID: <20101006142322.15b4aa26@absol.kitzblitz>
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

Fix typo in copyright notice.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 arch/x86/kvm/emulate.c     |    2 +-
 arch/x86/kvm/i8254.c       |    2 +-
 arch/x86/kvm/i8259.c       |    2 +-
 arch/x86/kvm/irq.c         |    2 +-
 arch/x86/kvm/lapic.c       |    2 +-
 arch/x86/kvm/mmu.c         |    2 +-
 arch/x86/kvm/mmu_audit.c   |    2 +-
 arch/x86/kvm/paging_tmpl.h |    2 +-
 arch/x86/kvm/svm.c         |    2 +-
 arch/x86/kvm/timer.c       |    2 +-
 arch/x86/kvm/vmx.c         |    2 +-
 arch/x86/kvm/x86.c         |    2 +-
 virt/kvm/irq_comm.c        |    2 +-
 virt/kvm/kvm_main.c        |    2 +-
 14 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index aead72e..cb8bd2e 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -9,7 +9,7 @@
  * privileged instructions:
  *
  * Copyright (C) 2006 Qumranet
- * Copyright 2010 Red Hat, Inc. and/or its affilates.
+ * Copyright 2010 Red Hat, Inc. and/or its affiliates.
  *
  *   Avi Kivity <avi@qumranet.com>
  *   Yaniv Kamay <yaniv@qumranet.com>
diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index 2ad40a4..efad723 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -5,7 +5,7 @@
  * Copyright (c) 2006 Intel Corporation
  * Copyright (c) 2007 Keir Fraser, XenSource Inc
  * Copyright (c) 2008 Intel Corporation
- * Copyright 2009 Red Hat, Inc. and/or its affilates.
+ * Copyright 2009 Red Hat, Inc. and/or its affiliates.
  *
  * Permission is hereby granted, free of charge, to any person obtaining a copy
  * of this software and associated documentation files (the "Software"), to deal
diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
index 6e77471..cf585f7 100644
--- a/arch/x86/kvm/i8259.c
+++ b/arch/x86/kvm/i8259.c
@@ -3,7 +3,7 @@
  *
  * Copyright (c) 2003-2004 Fabrice Bellard
  * Copyright (c) 2007 Intel Corporation
- * Copyright 2009 Red Hat, Inc. and/or its affilates.
+ * Copyright 2009 Red Hat, Inc. and/or its affiliates.
  *
  * Permission is hereby granted, free of charge, to any person obtaining a copy
  * of this software and associated documentation files (the "Software"), to deal
diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index f994da4..7e06ba1 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -1,7 +1,7 @@
 /*
  * irq.c: API for in kernel interrupt controller
  * Copyright (c) 2007, Intel Corporation.
- * Copyright 2009 Red Hat, Inc. and/or its affilates.
+ * Copyright 2009 Red Hat, Inc. and/or its affiliates.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms and conditions of the GNU General Public License,
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 22b06f7..ed1a533 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -5,7 +5,7 @@
  * Copyright (C) 2006 Qumranet, Inc.
  * Copyright (C) 2007 Novell
  * Copyright (C) 2007 Intel
- * Copyright 2009 Red Hat, Inc. and/or its affilates.
+ * Copyright 2009 Red Hat, Inc. and/or its affiliates.
  *
  * Authors:
  *   Dor Laor <dor.laor@qumranet.com>
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 6e248d8..3c7d024 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -7,7 +7,7 @@
  * MMU support
  *
  * Copyright (C) 2006 Qumranet, Inc.
- * Copyright 2010 Red Hat, Inc. and/or its affilates.
+ * Copyright 2010 Red Hat, Inc. and/or its affiliates.
  *
  * Authors:
  *   Yaniv Kamay  <yaniv@qumranet.com>
diff --git a/arch/x86/kvm/mmu_audit.c b/arch/x86/kvm/mmu_audit.c
index bd2b1be..ee0feef 100644
--- a/arch/x86/kvm/mmu_audit.c
+++ b/arch/x86/kvm/mmu_audit.c
@@ -4,7 +4,7 @@
  * Audit code for KVM MMU
  *
  * Copyright (C) 2006 Qumranet, Inc.
- * Copyright 2010 Red Hat, Inc. and/or its affilates.
+ * Copyright 2010 Red Hat, Inc. and/or its affiliates.
  *
  * Authors:
  *   Yaniv Kamay  <yaniv@qumranet.com>
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 2bdd843..30cde53 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -7,7 +7,7 @@
  * MMU support
  *
  * Copyright (C) 2006 Qumranet, Inc.
- * Copyright 2010 Red Hat, Inc. and/or its affilates.
+ * Copyright 2010 Red Hat, Inc. and/or its affiliates.
  *
  * Authors:
  *   Yaniv Kamay  <yaniv@qumranet.com>
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index eeb08d6..a7fdd78 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -4,7 +4,7 @@
  * AMD SVM support
  *
  * Copyright (C) 2006 Qumranet, Inc.
- * Copyright 2010 Red Hat, Inc. and/or its affilates.
+ * Copyright 2010 Red Hat, Inc. and/or its affiliates.
  *
  * Authors:
  *   Yaniv Kamay  <yaniv@qumranet.com>
diff --git a/arch/x86/kvm/timer.c b/arch/x86/kvm/timer.c
index e16a0db..fc7a101 100644
--- a/arch/x86/kvm/timer.c
+++ b/arch/x86/kvm/timer.c
@@ -6,7 +6,7 @@
  *
  * timer support
  *
- * Copyright 2010 Red Hat, Inc. and/or its affilates.
+ * Copyright 2010 Red Hat, Inc. and/or its affiliates.
  *
  * This work is licensed under the terms of the GNU GPL, version 2.  See
  * the COPYING file in the top-level directory.
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 0a70194..e5bc464 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -5,7 +5,7 @@
  * machines without emulation or binary translation.
  *
  * Copyright (C) 2006 Qumranet, Inc.
- * Copyright 2010 Red Hat, Inc. and/or its affilates.
+ * Copyright 2010 Red Hat, Inc. and/or its affiliates.
  *
  * Authors:
  *   Avi Kivity   <avi@qumranet.com>
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5733073..778dc86 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6,7 +6,7 @@
  * Copyright (C) 2006 Qumranet, Inc.
  * Copyright (C) 2008 Qumranet, Inc.
  * Copyright IBM Corporation, 2008
- * Copyright 2010 Red Hat, Inc. and/or its affilates.
+ * Copyright 2010 Red Hat, Inc. and/or its affiliates.
  *
  * Authors:
  *   Avi Kivity   <avi@qumranet.com>
diff --git a/virt/kvm/irq_comm.c b/virt/kvm/irq_comm.c
index 369e380..8edca91 100644
--- a/virt/kvm/irq_comm.c
+++ b/virt/kvm/irq_comm.c
@@ -17,7 +17,7 @@
  * Authors:
  *   Yaozu (Eddie) Dong <Eddie.dong@intel.com>
  *
- * Copyright 2010 Red Hat, Inc. and/or its affilates.
+ * Copyright 2010 Red Hat, Inc. and/or its affiliates.
  */
 
 #include <linux/kvm_host.h>
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 3ff01d0..aed2f90 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5,7 +5,7 @@
  * machines without emulation or binary translation.
  *
  * Copyright (C) 2006 Qumranet, Inc.
- * Copyright 2010 Red Hat, Inc. and/or its affilates.
+ * Copyright 2010 Red Hat, Inc. and/or its affiliates.
  *
  * Authors:
  *   Avi Kivity   <avi@qumranet.com>
-- 
1.7.2.2
