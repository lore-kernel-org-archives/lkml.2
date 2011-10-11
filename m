Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751194Ab1JKVtx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 17:49:53 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:61761 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791Ab1JKVtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 17:49:52 -0400
Message-ID: <4E94B9FD.5030500@tilera.com>
Date: Tue, 11 Oct 2011 17:49:49 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] arch/tile update for 3.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the following trivial change for 3.1 from:

  git://github.com/cmetcalf-tilera/linux-tile.git stable

This change allows 3.1-rc9 to build for the Tile architecture.  A bombing
of <asm/atomic.h> to <linux/atomic.h> erroneously modified a couple
of places where we were relying on some assembly constants in the tile
<asm/atomic.h>.  Thanks!

Chris Metcalf (1):
      tile: revert change from <asm/atomic.h> to <linux/atomic.h> in asm files

 arch/tile/kernel/intvec_32.S  |    2 +-
 arch/tile/lib/atomic_asm_32.S |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

