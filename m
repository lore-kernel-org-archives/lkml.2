Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130Ab2F0Gxz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 02:53:55 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:8336 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754131Ab2F0Gxx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 02:53:53 -0400
X-IronPort-AV: E=Sophos;i="4.77,483,1336320000"; 
   d="scan'208";a="5272443"
Message-ID: <4FEAAF0B.9080902@cn.fujitsu.com>
Date: Wed, 27 Jun 2012 14:58:19 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>
Subject: [PATCH 2/6 v5] update linux headers
References: <4FEAAE6E.7070302@cn.fujitsu.com>
In-Reply-To: <4FEAAE6E.7070302@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/06/27 14:54:03,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/06/27 14:54:04,
	Serialize complete at 2012/06/27 14:54:04
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

