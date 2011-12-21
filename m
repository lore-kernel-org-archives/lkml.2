Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860Ab1LUSrn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 13:47:43 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:44432 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752438Ab1LUSrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 13:47:04 -0500
From: Matt Fleming <matt@console-pimps.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Matt Fleming <matt.fleming@intel.com>
Subject: [PATCH 0/2] block_sigmask() helper function
Date: Wed, 21 Dec 2011 18:46:59 +0000
Message-Id: <1324493221-4435-1-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

Hi Andrew,

Oleg doesn't have a repo on kernel.org yet and suggested that you
might take these patches through your -mm tree? Ideally I'd like to
get these two in for the 3.3 merge window because I've got a bunch of
other patches that can go through the respective maintainers' trees
once these two have been merged.

These two patches have been posted before (along with the other 40)
but I attempted to get them all merged in one go, which didn't really
work. The original thread is here,

      https://lkml.org/lkml/2011/8/19/411

Matt Fleming (2):
  sparc: Make SA_NOMASK a synonym of SA_NODEFER
  signal: Add block_sigmask() for adding sigmask to current->blocked

 arch/sparc/include/asm/signal.h |    3 ++-
 arch/x86/kernel/signal.c        |    6 +-----
 include/linux/signal.h          |    1 +
 kernel/signal.c                 |   21 +++++++++++++++++++++
 4 files changed, 25 insertions(+), 6 deletions(-)

-- 
1.7.4.4

