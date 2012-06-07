Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759509Ab2FGCs6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 22:48:58 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:57334 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754789Ab2FGCs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 22:48:57 -0400
Message-ID: <4FD01697.7060601@tilera.com>
Date: Wed, 6 Jun 2012 22:48:55 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] arch/tile update for 3.5-rc2
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull for 3.5-rc2 from:

  git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile.git master

These two minor bug fixes fix build failures from some changes
that were merged in during the 3.5 merge window.

Chris Metcalf (2):
      tile: remove cpu_idle_on_new_stack
      tile: add #include to unbreak build after generic init_task conversion

 arch/tile/include/asm/thread_info.h |    5 -----
 arch/tile/kernel/entry.S            |   14 --------------
 arch/tile/kernel/setup.c            |    1 +
 3 files changed, 1 insertions(+), 19 deletions(-)

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

