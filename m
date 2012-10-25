Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933841Ab2JYDml (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 23:42:41 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:14413 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757185Ab2JYDmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 23:42:39 -0400
X-IronPort-AV: E=Sophos;i="4.80,645,1344182400"; 
   d="scan'208";a="6064356"
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
Cc: Wen Congyang <wency@cn.fujitsu.com>, Hu Tao <hutao@cn.fujitsu.com>
Subject: [PATCH v11 2/6] update kernel headers
Date: Thu, 25 Oct 2012 11:42:34 +0800
Message-Id: <1351136563-15073-2-git-send-email-hutao@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.2
In-Reply-To: <0a2274eccf1b1dd420f16359f7e1de74fa2f9fbe.1351131144.git.hutao@cn.fujitsu.com>
References: <0a2274eccf1b1dd420f16359f7e1de74fa2f9fbe.1351131144.git.hutao@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/25 11:41:59,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/25 11:42:01,
	Serialize complete at 2012/10/25 11:42:01
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

update kernel headers to add pv event macros.

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Signed-off-by: Hu Tao <hutao@cn.fujitsu.com>
---
 linux-headers/asm-x86/kvm_para.h |    1 +
 linux-headers/linux/kvm_para.h   |    6 ++++++
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
index 7bdcf93..f6be0bb 100644
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
1.7.10.2

