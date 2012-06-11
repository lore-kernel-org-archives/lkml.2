Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883Ab2FKPdy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 11:33:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7541 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479Ab2FKPdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 11:33:53 -0400
From: Don Zickus <dzickus@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: baryluk@smp.if.uj.edu.pl, LKML <linux-kernel@vger.kernel.org>,
        JBeulich@suse.com, zhong@linux.vnet.ibm.com,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 0/2] x86,nmi: Section header fixes
Date: Mon, 11 Jun 2012 11:33:27 -0400
Message-Id: <1339428809-29360-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An earlier attempt at a fix for the problem described in the second patch was
committed to Ingo's tree.  Later a smaller/cleaner patch was posted.  This
series just reverts the original patch and then applies the second patch.

The second patch looks a lot cleaner this way instead of just provding the
delta patch on top.

Ingo, let me know if this is not what you want.

Cheers,
Don

Don Zickus (1):
  Revert "x86/nmi: Fix section mismatch warnings on 32-bit"

Li Zhong (1):
  x86,nmi: Fix section mismatch warnings on 32-bit

 arch/x86/include/asm/nmi.h     |   20 +++-----------------
 arch/x86/kernel/nmi_selftest.c |    7 ++++---
 2 files changed, 7 insertions(+), 20 deletions(-)

-- 
1.7.7.6

