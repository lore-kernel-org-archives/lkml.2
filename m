Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816Ab2GUHKJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 03:10:09 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:11146 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751563Ab2GUHKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 03:10:07 -0400
X-IronPort-AV: E=Sophos;i="4.77,628,1336320000"; 
   d="scan'208";a="5450279"
Message-ID: <500A56F3.5030609@cn.fujitsu.com>
Date: Sat, 21 Jul 2012 15:14:59 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>
Subject: [PATCH 2/6 v7] kvm: Update kernel headers
References: <500A565A.8080403@cn.fujitsu.com>
In-Reply-To: <500A565A.8080403@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/21 15:10:45,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/21 15:10:45,
	Serialize complete at 2012/07/21 15:10:45
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corresponding kvm.git hash: 37e41afa and apply my patch for kvm

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
---
 linux-headers/asm-x86/kvm_para.h |    2 ++
 linux-headers/linux/kvm_para.h   |    6 ++++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/linux-headers/asm-x86/kvm_para.h b/linux-headers/asm-x86/kvm_para.h
index f2ac46a..f9d858f 100644
--- a/linux-headers/asm-x86/kvm_para.h
+++ b/linux-headers/asm-x86/kvm_para.h
@@ -89,5 +89,7 @@ struct kvm_vcpu_pv_apf_data {
 	__u32 enabled;
 };
 
+#define KVM_PV_PORT	(0x505UL)
+
 
 #endif /* _ASM_X86_KVM_PARA_H */
diff --git a/linux-headers/linux/kvm_para.h b/linux-headers/linux/kvm_para.h
index 7bdcf93..4fbd625 100644
--- a/linux-headers/linux/kvm_para.h
+++ b/linux-headers/linux/kvm_para.h
@@ -20,6 +20,12 @@
 #define KVM_HC_FEATURES			3
 #define KVM_HC_PPC_MAP_MAGIC_PAGE	4
 
+/* The bit of the value read from KVM_PV_PORT */
+#define KVM_PV_FEATURE_PANICKED	0
+
+/* The value writen to KVM_PV_PORT */
+#define KVM_PV_PANICKED		1
+
 /*
  * hypercalls use architecture specific
  */
-- 
1.7.1

