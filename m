Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757109Ab2CWIJe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 04:09:34 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:54499 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756917Ab2CWIJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 04:09:20 -0400
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: X86 <x86@kernel.org>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Alexander Graf <agraf@suse.de>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Gleb Natapov <gleb@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Xen <xen-devel@lists.xensource.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Date: Fri, 23 Mar 2012 13:38:05 +0530
Message-Id: <20120323080801.14568.74307.sendpatchset@codeblue>
In-Reply-To: <20120323080503.14568.43092.sendpatchset@codeblue>
References: <20120323080503.14568.43092.sendpatchset@codeblue>
Subject: [PATCH RFC V5 4/6] kvm guest : Added configuration support to enable debug information for KVM Guests
x-cbid: 12032222-5140-0000-0000-000000F05038
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>

Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Signed-off-by: Suzuki Poulose <suzuki@in.ibm.com>
Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
---
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 10c28ec..a4530bd 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -600,6 +600,15 @@ config KVM_GUEST
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

