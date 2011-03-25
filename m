Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248Ab1CYVEg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 17:04:36 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53601
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755221Ab1CYVEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 17:04:34 -0400
Date: Fri, 25 Mar 2011 14:05:13 -0700 (PDT)
Message-Id: <20110325.140513.90785615.davem@davemloft.net>
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


Please pull to get this RTC probing bug fix.

Thanks!

The following changes since commit 40471856f2e38e9bfa8d605295e8234421110dd6:

  Merge branch 'nfs-for-2.6.39' of git://git.linux-nfs.org/projects/trondmy/nfs-2.6 (2011-03-25 10:03:28 -0700)

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

Kjetil Oftedal (1):
      sparc32: Fix multiple RTC detections on SUN4D

 arch/sparc/kernel/time_32.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)
