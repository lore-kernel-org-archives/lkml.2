Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757054Ab0EMCNN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 22:13:13 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49180 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751299Ab0EMCNK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 22:13:10 -0400
Message-ID: <4BEB5F75.4040409@cn.fujitsu.com>
Date: Thu, 13 May 2010 10:09:57 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/5] KVM x86: cleanup unused local variable
References: <4BEB5E8A.7030606@cn.fujitsu.com> <4BEB5EC4.6070802@cn.fujitsu.com> <4BEB5F08.3010604@cn.fujitsu.com> <4BEB5F38.1070508@cn.fujitsu.com>
In-Reply-To: <4BEB5F38.1070508@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix:
 arch/x86/kvm/x86.c: In function ‘handle_emulation_failure’:
 arch/x86/kvm/x86.c:3844: warning: unused variable ‘ctxt’

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/x86.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4b1433f..23a7716 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3841,8 +3841,6 @@ static void inject_emulated_exception(struct kvm_vcpu *vcpu)
 
 static int handle_emulation_failure(struct kvm_vcpu *vcpu)
 {
-	struct x86_emulate_ctxt *ctxt = &vcpu->arch.emulate_ctxt;
-
 	++vcpu->stat.insn_emulation_fail;
 	trace_kvm_emulate_insn_failed(vcpu);
 	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-- 
1.6.1.2


