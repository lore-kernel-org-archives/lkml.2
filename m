Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270Ab0K2QxT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 11:53:19 -0500
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:55238
	"EHLO DB3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755158Ab0K2QxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 11:53:16 -0500
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i691h668h67dh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LCNO6K-02-ELK-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] KVM: Introduce VCPU-wide notion of guest-mode V2
Date: Mon, 29 Nov 2010 17:51:46 +0100
Message-ID: <1291049509-3430-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <4CF3D093.40604@redhat.com>
References: <4CF3D093.40604@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Avi, Hi Marcelo,

here is the re-spin I promised. The change to V1 are essentially the
renames:

	kvm_vcpu_enter_gm -> enter_guest_mode
	kvm_vcpu_leave_gm -> leave_guest_mode
	kvm_vcpu_is_gm    -> is_guest_mode

No other changes are in this patch-set compared to V1.

Regards,
	Joerg

 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/kvm_cache_regs.h   |   15 +++++++++++++
 arch/x86/kvm/svm.c              |   44 ++++++++++++++++++--------------------
 arch/x86/kvm/x86.c              |   14 ++++++++---
 4 files changed, 47 insertions(+), 27 deletions(-)

Joerg Roedel (3):
      KVM: X86: Introduce generic guest-mode representation
      KVM: SVM: Make Use of the generic guest-mode functions
      KVM: X86: Don't report L2 emulation failures to user-space


