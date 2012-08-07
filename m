Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750982Ab2HGHmk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 03:42:40 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:46949 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809Ab2HGHmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 03:42:36 -0400
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: Alexander Graf <agraf@suse.de>, Randy Dunlap <rdunlap@xenotime.net>,
        KVM <kvm@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Avi Kivity <avi@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, X86 <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 07 Aug 2012 13:09:46 +0530
Message-Id: <20120807073946.20169.72958.sendpatchset@codeblue.in.ibm.com>
Subject: [PATCH 0/3] Documentation : hypercalls
x-cbid: 12080707-1618-0000-0000-000002364CF5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the hypercall documentation patch series
First patch covers KVM specific hypercall information.

second patch is has typo fix for vmcall instruction
comment in kvm_para.h

Third patch includes a veryful documentation on PowerPC
hypercalls originally written by Alex

Changes since initial post:
 - Added hypercall ABI (Peter)
 - made KVM_HC_VAPIC_POLL_IRQ active explicitly (Randy)
 - Changed vmrun/vmmrun ==> vmcall/vmmcall (Marcelo)
 - use Linux KVM hypercall instead of ABI  (Marcelo)
 - correct PowerPC typo (Alex)
 - Remove value field (Alex)

Raghavendra K T (2):
 Documentation/kvm : Add documentation on hypercalls
 Documentation/header : Correct vmrun to vmcall typo

Alexander Graf (1) :
 Documentation/ppc: Add ppc hypercall documentation

 Documentation/virtual/kvm/hypercalls.txt |   66 ++++++++++++++++++++++++++++++
 Documentation/virtual/kvm/ppc-pv.txt     |   22 ++++++++++
 arch/x86/include/asm/kvm_para.h          |    2 +-
 3 files changed, 89 insertions(+), 1 deletions(-)

