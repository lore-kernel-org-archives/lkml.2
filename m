Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933861Ab2C2ULt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 16:11:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38104 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759697Ab2C2ULj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 16:11:39 -0400
From: Don Zickus <dzickus@redhat.com>
To: <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        thomas.mingarelli@hp.com, Don Zickus <dzickus@redhat.com>
Subject: [PATCH 0/3] x86, nmi: Fixes
Date: Thu, 29 Mar 2012 16:11:14 -0400
Message-Id: <1333051877-15755-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch series started with fixes for kmemcheck but slowly involved
the fixing hpwdt.  Hopefully everything is ok for now.

Don Zickus (2):
  watchdog, hpwdt: Remove priority option for NMI callback
  x86, nmi: Add new NMI queues to deal with IO_CHK and SERR

Li Zhong (1):
  x86,nmi: Fix page faults by nmiaction if kmemcheck is enabled

 arch/x86/include/asm/nmi.h |   22 ++++++++++-
 arch/x86/kernel/nmi.c      |   83 +++++++++++++-------------------------------
 drivers/watchdog/hpwdt.c   |   46 +++++++++++++------------
 3 files changed, 68 insertions(+), 83 deletions(-)

-- 
1.7.7.6

