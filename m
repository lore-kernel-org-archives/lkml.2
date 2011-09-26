Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736Ab1IZLr0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 07:47:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1529 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752269Ab1IZLrZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 07:47:25 -0400
Message-ID: <4E806649.90803@redhat.com>
Date: Mon, 26 Sep 2011 14:47:21 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: KVM list <kvm@vger.kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] KVM updates for 3.1-rc7
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from:

   git://github.com/avikivity/kvm.git kvm-updates/3.1

to receive an emulator fix affecting shld/shrd and a softmmu issue on 
i386 hosts.

Avi Kivity (1):
       KVM: x86 emulator: fix Src2CL decode

Zhao Jin (1):
       KVM: MMU: fix incorrect return of spte

  arch/x86/kvm/emulate.c |    2 +-
  arch/x86/kvm/mmu.c     |    3 ++-
  2 files changed, 3 insertions(+), 2 deletions(-)

-- 
error compiling committee.c: too many arguments to function

