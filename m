Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638Ab0ITONh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 10:13:37 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54764 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756606Ab0ITONf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 10:13:35 -0400
Message-ID: <4C976D0C.1070302@cn.fujitsu.com>
Date: Mon, 20 Sep 2010 22:17:48 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 2/2] KVM: document 'kvm.mmu_audit' parameter
References: <4C976CCD.4030406@cn.fujitsu.com>
In-Reply-To: <4C976CCD.4030406@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document this parameter into Documentation/kernel-parameters.txt

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 Documentation/kernel-parameters.txt |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 3170edb..8dc2548 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1126,6 +1126,10 @@ and is between 256 and 4096 characters. It is defined in the file
 	kvm.oos_shadow=	[KVM] Disable out-of-sync shadow paging.
 			Default is 1 (enabled)
 
+	kvm.mmu_audit=	[KVM] This is a R/W parameter which allows audit
+			KVM MMU at runtime.
+			Default is 0 (off)
+
 	kvm-amd.nested=	[KVM,AMD] Allow nested virtualization in KVM/SVM.
 			Default is 1 (enabled)
 
-- 
1.7.0.4
