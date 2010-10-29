Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760554Ab0J2Dou (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 23:44:50 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33121
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758164Ab0J2Doo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 23:44:44 -0400
Date: Thu, 28 Oct 2010 20:45:07 -0700 (PDT)
Message-Id: <20101028.204507.193718797.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] IDE
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull to get these IDE changes for 2.6.36, thanks!

The following changes since commit b18cae4224bde7e5a332c19bc99247b2098ea232:

  Merge branch 'for-next' of git://android.git.kernel.org/kernel/tegra (2010-10-25 18:42:06 -0700)

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/ide-2.6.git master

Sergei Shtylyov (2):
      hpt366: add debounce delay to cable_detect() method
      hpt366: fix clock turnaround

Tejun Heo (1):
      ide: clean up timed out request handling

 drivers/ide/hpt366.c  |   14 ++++++++------
 drivers/ide/ide-dma.c |   11 +++--------
 2 files changed, 11 insertions(+), 14 deletions(-)
