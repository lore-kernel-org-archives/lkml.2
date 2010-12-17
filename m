Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518Ab0LQPSD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 10:18:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32328 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869Ab0LQPSB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 10:18:01 -0500
Message-ID: <4D0B7F21.3000103@redhat.com>
Date: Fri, 17 Dec 2010 17:17:53 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm-devel <kvm@vger.kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [GIT PULL] KVM updates fot 2.6.37-rc6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

   git://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-updates/2.6.37

to get a few KVM fixes for 2.6.37-rc6.  Two of the fixes are for forward 
compatibility with Bulldozer processors, one is a live migration fix, 
and one an ordinary preemption counter leak fix.

Andre Przywara (1):
       KVM: enlarge number of possible CPUID leaves

Avi Kivity (1):
       KVM: Fix preemption counter leak in kvm_timer_init()

Joerg Roedel (1):
       KVM: SVM: Do not report xsave in supported cpuid

Sheng Yang (1):
       KVM: Fix OSXSAVE after migration

  arch/x86/include/asm/kvm_host.h |    2 +-
  arch/x86/kvm/svm.c              |    4 ++++
  arch/x86/kvm/vmx.c              |    5 -----
  arch/x86/kvm/x86.c              |   11 +++++------
  arch/x86/kvm/x86.h              |    5 +++++
  5 files changed, 15 insertions(+), 12 deletions(-)

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

