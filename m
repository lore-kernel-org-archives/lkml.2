Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454Ab2EUGqj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 02:46:39 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63224 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751011Ab2EUGqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 02:46:37 -0400
X-IronPort-AV: E=Sophos;i="4.75,630,1330876800"; 
   d="scan'208";a="5001027"
Message-ID: <4FB9E5A5.4080500@cn.fujitsu.com>
Date: Mon, 21 May 2012 14:50:13 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>
Subject: [PATCH 2/3] update linux headers
References: <4FB9E4CE.8060709@cn.fujitsu.com>
In-Reply-To: <4FB9E4CE.8060709@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/05/21 14:45:12,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/05/21 14:45:13,
	Serialize complete at 2012/05/21 14:45:13
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
---
 linux-headers/linux/kvm_para.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/linux-headers/linux/kvm_para.h b/linux-headers/linux/kvm_para.h
index 7bdcf93..5618758 100644
--- a/linux-headers/linux/kvm_para.h
+++ b/linux-headers/linux/kvm_para.h
@@ -20,6 +20,14 @@
 #define KVM_HC_FEATURES			3
 #define KVM_HC_PPC_MAP_MAGIC_PAGE	4
 
+#define KVM_PV_PORT	(0x505UL)
+
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

