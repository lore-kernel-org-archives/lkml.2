Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527Ab0HVSXe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 14:23:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36285 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752050Ab0HVSXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 14:23:31 -0400
Message-ID: <4C716AFC.1080608@redhat.com>
Date: Sun, 22 Aug 2010 21:22:52 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Thunderbird/3.1.2
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm-devel <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] KVM fixes for 2.6.36-rc1
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Linus, please pull from r&b:

   git://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-updates/2.6.36

to get a few regression fixes for KVM:

Xiao Guangrong (1):
       KVM: PIT: free irq source id in handling error path

Xiaotian Feng (2):
       KVM: fix poison overwritten caused by using wrong xstate size
       KVM: destroy workqueue on kvm_create_pit() failures

  arch/x86/kernel/i387.c |    1 +
  arch/x86/kvm/i8254.c   |    3 ++-
  arch/x86/kvm/x86.c     |    4 ++--
  3 files changed, 5 insertions(+), 3 deletions(-)

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

