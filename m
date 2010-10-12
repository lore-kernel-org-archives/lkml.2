Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757701Ab0JLQOq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 12:14:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58553 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751585Ab0JLQOp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 12:14:45 -0400
Message-ID: <4CB4893A.6020203@redhat.com>
Date: Tue, 12 Oct 2010 18:13:46 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: [GIT PULL] KVM fixes for 2.3.36-rc7
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Linus, please pull a critical fix (in two commits) for the tsc on AMD 
hosts, from

   git://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-updates/2.6.36

Thanks.  Changelog/diffstat:

Zachary Amsden (2):
       KVM: x86: Fix SVM VMCB reset
       KVM: x86: Move TSC reset out of vmcb_init

  arch/x86/kvm/svm.c |    2 +-
  1 files changed, 1 insertions(+), 1 deletions(-)

-- 
error compiling committee.c: too many arguments to function

