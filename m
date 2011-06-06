Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540Ab1FFObN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 10:31:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62441 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752048Ab1FFObL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 10:31:11 -0400
Message-ID: <4DECE4A9.4030505@redhat.com>
Date: Mon, 06 Jun 2011 17:31:05 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: KVM list <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] KVM updates for 3.0-rc2
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

   ssh://master.kernel.org/pub/scm/virt/kvm/kvm.git kvm-updates/3.0

to receive a few KVM fixes for -rc2.  In particular, guest in/out 
instructions have been faulting when they shouldn't have.


Heiko Carstens (1):
       KVM: add missing void __user * cast to access_ok() call

Marcelo Tosatti (1):
       KVM: x86: use proper port value when checking io instruction 
permission

Mike Waychison (1):
       KVM: Initialize kvm before registering the mmu notifier

  arch/x86/kvm/emulate.c |   82 
+++++++++++++++++++++++++++--------------------
  virt/kvm/kvm_main.c    |   15 +++++---
  2 files changed, 56 insertions(+), 41 deletions(-)

-- 
error compiling committee.c: too many arguments to function

