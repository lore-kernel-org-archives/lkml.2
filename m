Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759124Ab2GLLzn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 07:55:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61769 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754437Ab2GLLzm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 07:55:42 -0400
Message-ID: <4FFEBB39.8090308@redhat.com>
Date: Thu, 12 Jul 2012 14:55:37 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>
Subject: [GIT PULL] KVM fixes for 3.5-rc6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull a couple of KVM fixes from:

  git://git.kernel.org/pub/scm/virt/kvm/kvm.git master

One is an adjustment for an irq layer change that affected device
assignment, the other a one-liner ppc fix.

----------------------------------------------------------------

Alex Williamson (1):
      KVM: Fix device assignment threaded irq handler

Avi Kivity (1):
      Merge branch 'for-upstream-master' of git://github.com/agraf/linux-2.6

Benjamin Herrenschmidt (1):
      powerpc/kvm: Fix "PR" KVM implementation of H_CEDE

-- 
error compiling committee.c: too many arguments to function

