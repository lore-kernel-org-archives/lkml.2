Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752Ab1HPSKy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 14:10:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38532 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751782Ab1HPSKw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 14:10:52 -0400
Message-ID: <4E4AB287.50600@redhat.com>
Date: Tue, 16 Aug 2011 11:10:15 -0700
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm-devel <kvm@vger.kernel.org>
Subject: [GIT PULL] KVM updates for 3.1-rc2
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from

   ssh://master.kernel.org/pub/scm/virt/kvm/kvm.git kvm-updates/3.1

to receive fixes for Kconfig problems introduced by the KVM steal time 
implementation.

Randy Dunlap (2):
       KVM: fix TASK_DELAY_ACCT kconfig warning
       KVM: uses TASKSTATS, depends on NET

  arch/x86/kvm/Kconfig |    3 +++
  1 files changed, 3 insertions(+), 0 deletions(-)

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

