Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042Ab2EBKJq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 06:09:46 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:52789 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510Ab2EBKJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 06:09:43 -0400
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Avi Kivity <avi@redhat.com>,
        X86 <x86@kernel.org>, Gleb Natapov <gleb@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: Attilio Rao <attilio.rao@citrix.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        linux-doc@vger.kernel.org,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        KVM <kvm@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Stephan Diestelhorst <stephan.diestelhorst@amd.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 02 May 2012 15:39:21 +0530
Message-Id: <20120502100921.13206.19019.sendpatchset@codeblue.in.ibm.com>
In-Reply-To: <20120502100610.13206.40.sendpatchset@codeblue.in.ibm.com>
References: <20120502100610.13206.40.sendpatchset@codeblue.in.ibm.com>
Subject: [PATCH RFC V8 15/17] kvm guest : Add configuration support to enable debug information for KVM Guests
x-cbid: 12050200-7014-0000-0000-0000010449DB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>

Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Signed-off-by: Suzuki Poulose <suzuki@in.ibm.com>
Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
---
 arch/x86/Kconfig |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 35eb2e4..a9ec0da 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -584,6 +584,15 @@ config KVM_GUEST
 	  This option enables various optimizations for running under the KVM
 	  hypervisor.
 
+config KVM_DEBUG_FS
+	bool "Enable debug information for KVM Guests in debugfs"
+	depends on KVM_GUEST && DEBUG_FS
+	default n
+	---help---
+	  This option enables collection of various statistics for KVM guest.
+   	  Statistics are displayed in debugfs filesystem. Enabling this option
+	  may incur significant overhead.
+
 source "arch/x86/lguest/Kconfig"
 
 config PARAVIRT

