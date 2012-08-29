Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798Ab2H2Xca (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 19:32:30 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62670 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754677Ab2H2Xbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 19:31:41 -0400
From: Mathias Krause <minipli@googlemail.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>
Subject: [PATCH 6/8] KVM: x86: more constification
Date: Thu, 30 Aug 2012 01:30:18 +0200
Message-Id: <1346283020-22385-7-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1346283020-22385-1-git-send-email-minipli@googlemail.com>
References: <1346283020-22385-1-git-send-email-minipli@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mathias Krause <minipli@googlemail.com>
---
 arch/x86/kvm/lapic.c |    2 +-
 arch/x86/kvm/x86.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 18d149d..07ad628 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -198,7 +198,7 @@ static inline int apic_x2apic_mode(struct kvm_lapic *apic)
 	return apic->vcpu->arch.apic_base & X2APIC_ENABLE;
 }
 
-static unsigned int apic_lvt_mask[APIC_LVT_NUM] = {
+static const unsigned int apic_lvt_mask[APIC_LVT_NUM] = {
 	LVT_MASK ,      /* part LVTT mask, timer mode mask added at runtime */
 	LVT_MASK | APIC_MODE_MASK,	/* LVTTHMR */
 	LVT_MASK | APIC_MODE_MASK,	/* LVTPC */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 79ac03c..d981008 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -817,7 +817,7 @@ static u32 msrs_to_save[] = {
 
 static unsigned num_msrs_to_save;
 
-static u32 emulated_msrs[] = {
+static const u32 emulated_msrs[] = {
 	MSR_IA32_TSCDEADLINE,
 	MSR_IA32_MISC_ENABLE,
 	MSR_IA32_MCG_STATUS,
-- 
1.7.10.4

