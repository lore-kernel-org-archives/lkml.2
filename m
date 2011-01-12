Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932731Ab1ALA02 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 19:26:28 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60829
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932575Ab1ALA00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 19:26:26 -0500
Date: Tue, 11 Jan 2011 16:26:59 -0800 (PST)
Message-Id: <20110111.162659.172602331.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This fixes a bootup regression caused by some recent perf NMI changes.

Please pull, thanks a lot!

The following changes since commit 7bc4a4ce68f8c6d064ea949446852e996526f692:

  Merge branch 'for-linus-merged' of git://oss.sgi.com/xfs/xfs (2011-01-11 11:42:06 -0800)

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

David S. Miller (1):
      sparc64: Fix bootup regression due to perf init ordering.

 arch/sparc/kernel/cpu.c |    2 +-
 arch/sparc/kernel/pcr.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)
