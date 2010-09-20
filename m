Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543Ab0ITOM3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 10:12:29 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57197 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756437Ab0ITOM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 10:12:27 -0400
Message-ID: <4C976CCD.4030406@cn.fujitsu.com>
Date: Mon, 20 Sep 2010 22:16:45 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 1/2] KVM: fix the description of kvm-amd.nested in documentation
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The default state of 'kvm-amd.nested' is enabled now, so fix the documentation

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 Documentation/kernel-parameters.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 6bd2375..3170edb 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1127,7 +1127,7 @@ and is between 256 and 4096 characters. It is defined in the file
 			Default is 1 (enabled)
 
 	kvm-amd.nested=	[KVM,AMD] Allow nested virtualization in KVM/SVM.
-			Default is 0 (off)
+			Default is 1 (enabled)
 
 	kvm-amd.npt=	[KVM,AMD] Disable nested paging (virtualized MMU)
 			for all guests.
-- 
1.7.0.4
