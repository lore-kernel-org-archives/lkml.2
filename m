Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855Ab0GYMCk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 08:02:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61906 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189Ab0GYMCi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 08:02:38 -0400
Message-ID: <4C4C27D4.1010607@redhat.com>
Date: Sun, 25 Jul 2010 15:02:28 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] KVM fixes for 2.6.35-rc6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Linus, please pull from

   git://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-updates/2.6.35

to get a couple of fairly critical fixes for 2.6.35-rc6.  One works 
around the vmalloc() performance regression, the fix for which did not 
make it into 2.6.35, and the other fixes failures of the RHEL 6 beta as 
a guest, which has been frequently reported.

Avi Kivity (1):
       KVM: Use kmalloc() instead of vmalloc() for KVM_[GS]ET_MSR

Xiao Guangrong (1):
       KVM: MMU: fix conflict access permissions in direct sp

  arch/x86/kvm/paging_tmpl.h |    1 +
  arch/x86/kvm/x86.c         |    4 ++--
  2 files changed, 3 insertions(+), 2 deletions(-)

-- 
error compiling committee.c: too many arguments to function

