Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379Ab1F2Lne (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 07:43:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44794 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751769Ab1F2Lnc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 07:43:32 -0400
Message-ID: <4E0B0FDE.1070505@redhat.com>
Date: Wed, 29 Jun 2011 14:43:26 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [GIT PULL] KVM fix for Linux 3.0-rc5
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

are available in the git repository at:
   git://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-updates/3.0

To receive a single KVM fix.  Emulated instructions which had both an 
immediate operand and an %rip-relative operand did not compute the 
effective address correctly; this is now fixed.

Avi Kivity (1):
       KVM: x86 emulator: fix %rip-relative addressing with immediate 
source operand

  arch/x86/kvm/emulate.c |   12 +++++++-----
  1 files changed, 7 insertions(+), 5 deletions(-)

-- 
error compiling committee.c: too many arguments to function

