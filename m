Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111Ab1IEJml (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 05:42:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35739 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721Ab1IEJmh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 05:42:37 -0400
Message-ID: <4E649986.5060606@redhat.com>
Date: Mon, 05 Sep 2011 12:42:30 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: KVM list <kvm@vger.kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] KVM fix for 3.1-rc5
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

   git://github.com/avikivity/kvm.git kvm-updates/3.1

to receive a fix for a build failure due to a missing instruction size 
suffix in inline assembly.

Duncan Sands (1):
       KVM: Fix instruction size issue in pvclock scaling

  arch/x86/include/asm/pvclock.h |    2 +-
  1 files changed, 1 insertions(+), 1 deletions(-)

-- 
error compiling committee.c: too many arguments to function

