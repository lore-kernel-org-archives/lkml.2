Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755687Ab1DGLp0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 07:45:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5781 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753038Ab1DGLpY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 07:45:24 -0400
Message-ID: <4D9DA3CD.8060602@redhat.com>
Date: Thu, 07 Apr 2011 14:45:17 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] KVM updates for 2.6.39-rc2
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the repo/branch at:

   git://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-updates/2.6.39

to receive a fix for virtualized cpuid and a host irqfd oops, as well as 
a patch that enables asynchronous page faults, which was merged in 
2.6.38 but not enabled.

Andre Przywara (2):
       KVM: fix XSAVE bit scanning
       KVM: move and fix substitue search for missing CPUID entries

Gleb Natapov (1):
       KVM: Enable async page fault processing

Michael S. Tsirkin (1):
       KVM: fix crash on irqfd deassign

  arch/x86/kvm/x86.c  |   37 ++++++++++++++++++++++++++++---------
  virt/kvm/eventfd.c  |    2 +-
  virt/kvm/kvm_main.c |   23 +++++++++++++++++++++--
  3 files changed, 50 insertions(+), 12 deletions(-)

-- 
error compiling committee.c: too many arguments to function

