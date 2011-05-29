Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab1E2MbR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 08:31:17 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:43169 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098Ab1E2MbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 08:31:16 -0400
Message-ID: <4DE23C91.90107@tilera.com>
Date: Sun, 29 May 2011 08:31:13 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [GIT PULL] additional arch/tile change for 2.6.40
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull for 2.6.40 from:

  git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile.git master

This adds one final piece of functionality for the tile port that I
delayed from the initial pull request since it required more back and
forth on LKML before it was fully baked.  It is support for some
limited /proc/tile and /proc/sys/tile hooks, plus a bunch of stuff in
sysfs (in /sys/hypervisor and /sys/devices/system/cpu).

The final version was reviewed by Arnd and is in linux-next.  Thanks!

Chris Metcalf (1):
      arch/tile: more /proc and /sys file support

 arch/tile/Kconfig                |    1 +
 arch/tile/include/asm/hardwall.h |   15 +++-
 arch/tile/kernel/Makefile        |    2 +-
 arch/tile/kernel/hardwall.c      |   90 ++++++++++++++-----
 arch/tile/kernel/proc.c          |   73 +++++++++++++++
 arch/tile/kernel/sysfs.c         |  185 ++++++++++++++++++++++++++++++++++++++
 fs/proc/base.c                   |    9 ++
 7 files changed, 347 insertions(+), 28 deletions(-)
 create mode 100644 arch/tile/kernel/sysfs.c


-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com


