Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110Ab1BJJu1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 04:50:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41983 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753335Ab1BJJu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 04:50:26 -0500
Message-ID: <4D53B4DB.303@redhat.com>
Date: Thu, 10 Feb 2011 11:50:19 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [GIT PULL] KVM fix for 2.6.38-rc4
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull a KVM fix from

   git://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-updates/2.6.38

This closes a small window during which an NMI could kill an AMD host.

Joerg Roedel (1):
       KVM: SVM: Make sure KERNEL_GS_BASE is valid when loading gs_index

  arch/x86/kvm/svm.c |    2 +-
  1 files changed, 1 insertions(+), 1 deletions(-)

-- 
error compiling committee.c: too many arguments to function

