Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758163Ab2FEOii (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 10:38:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27502 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753711Ab2FEOih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 10:38:37 -0400
Message-ID: <4FCE19E9.2080109@redhat.com>
Date: Tue, 05 Jun 2012 17:38:33 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>
Subject: [GIT PULL] KVM fix for 3.5-rc1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from

  git://git.kernel.org/pub/scm/virt/kvm/kvm.git master

to receive a one-liner fix for a buffer overflow:

  KVM: Fix buffer overflow in kvm_set_irq() (2012-06-05 16:39:58 +0300)

----------------------------------------------------------------
Avi Kivity (1):
      KVM: Fix buffer overflow in kvm_set_irq()

 virt/kvm/irq_comm.c |    1 +
 1 file changed, 1 insertion(+)

-- 
error compiling committee.c: too many arguments to function
