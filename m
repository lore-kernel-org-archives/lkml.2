Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760747Ab2DKRCs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 13:02:48 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:18058 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756012Ab2DKRCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 13:02:47 -0400
Message-ID: <4F85B933.9080302@tilera.com>
Date: Wed, 11 Apr 2012 13:02:43 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] arch/tile bug fixes for v3.4-rc3
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the following changes for 3.4-rc2 from:

  git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile.git stable

This is one important change from Srivatsa Bhat that got dropped when I
put together my pull request for -rc2, plus a trivial change to remove a compiler
warning.

Chris Metcalf (1):
      arch/tile: avoid unused variable warning in proc.c for tilegx

Srivatsa S. Bhat (1):
      tile/CPU hotplug: Add missing call to notify_cpu_starting()

 arch/tile/kernel/proc.c    |    4 +---
 arch/tile/kernel/smpboot.c |    2 ++
 2 files changed, 3 insertions(+), 3 deletions(-)

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

