Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935Ab1BXRUl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 12:20:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57430 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125Ab1BXRUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 12:20:38 -0500
Message-ID: <4D66935F.8000904@redhat.com>
Date: Thu, 24 Feb 2011 19:20:31 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: KVM list <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [GIT PULL] KVM fix for 2.6.38-rc6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

   git://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-updates/2.6.38

to receive a fix which restores a hunk which was inadvertently left off 
its original patch.  It fixes MOV DR instruction emulation on AMD 
Bulldozers.

Joerg Roedel (1):
       KVM: SVM: Advance instruction pointer in dr_intercept

  arch/x86/kvm/svm.c |    2 ++
  1 files changed, 2 insertions(+), 0 deletions(-)

-- 
error compiling committee.c: too many arguments to function

