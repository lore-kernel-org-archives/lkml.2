Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231Ab2LLGQn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 01:16:43 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:27919 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750946Ab2LLGN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 01:13:58 -0500
X-IronPort-AV: E=Sophos;i="4.84,264,1355068800"; 
   d="scan'208";a="6380973"
From: Hu Tao <hutao@cn.fujitsu.com>
To: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>,
        Blue Swirl <blauwirbel@gmail.com>, Eric Blake <eblake@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Luiz Capitulino <lcapitulino@redhat.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Subject: [PATCH v12 3/8] update kernel headers
Date: Wed, 12 Dec 2012 14:13:46 +0800
Message-Id: <1c9f07bec8f11e8f45ca55cecde7881da0b31762.1355290850.git.hutao@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.0.1.240.ge8a1f5a
In-Reply-To: <cover.1355290850.git.hutao@cn.fujitsu.com>
References: <cover.1355290850.git.hutao@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/12 14:13:05,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/12 14:13:06,
	Serialize complete at 2012/12/12 14:13:06
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

update kernel headers to add pv event macros.

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Signed-off-by: Hu Tao <hutao@cn.fujitsu.com>
---
 linux-headers/asm-x86/kvm_para.h | 1 +
 linux-headers/linux/kvm_para.h   | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/linux-headers/asm-x86/kvm_para.h b/linux-headers/asm-x86/kvm_para.h
index a1c3d72..781959a 100644
--- a/linux-headers/asm-x86/kvm_para.h
+++ b/linux-headers/asm-x86/kvm_para.h
@@ -96,5 +96,6 @@ struct kvm_vcpu_pv_apf_data {
 #define KVM_PV_EOI_ENABLED KVM_PV_EOI_MASK
 #define KVM_PV_EOI_DISABLED 0x0
 
+#define KVM_PV_EVENT_PORT	(0x505UL)
 
 #endif /* _ASM_X86_KVM_PARA_H */
diff --git a/linux-headers/linux/kvm_para.h b/linux-headers/linux/kvm_para.h
index cea2c5c..c41ddce 100644
--- a/linux-headers/linux/kvm_para.h
+++ b/linux-headers/linux/kvm_para.h
@@ -20,6 +20,12 @@
 #define KVM_HC_FEATURES			3
 #define KVM_HC_PPC_MAP_MAGIC_PAGE	4
 
+/* The bit of supported pv event */
+#define KVM_PV_FEATURE_PANICKED	0
+
+/* The pv event value */
+#define KVM_PV_EVENT_PANICKED	1
+
 /*
  * hypercalls use architecture specific
  */
-- 
1.8.0.1.240.ge8a1f5a

