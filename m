Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933480Ab2C2O4d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 10:56:33 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:16917 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933463Ab2C2O4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 10:56:19 -0400
Message-ID: <4F747811.4060201@tilera.com>
Date: Thu, 29 Mar 2012 10:56:17 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] arch/tile (really asm-generic) update for 3.4
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the following changes for 3.4 from:

  git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile.git master

These are a couple of asm-generic changes that apply to tile.

Chris Metcalf (2):
      ipc: provide generic compat versions of IPC syscalls
      compat: use sys_sendfile64() implementation for sendfile syscall

 arch/Kconfig                   |    3 ++
 arch/mips/Kconfig              |    1 +
 arch/powerpc/Kconfig           |    1 +
 arch/s390/Kconfig              |    1 +
 arch/sparc/Kconfig             |    1 +
 arch/tile/include/asm/compat.h |   11 ------
 arch/tile/kernel/compat.c      |   43 ------------------------
 arch/x86/Kconfig               |    1 +
 include/asm-generic/unistd.h   |    2 +-
 include/linux/compat.h         |   12 ++++++-
 ipc/compat.c                   |   70 ++++++++++++++++++++++++++++++++++++---
 11 files changed, 84 insertions(+), 62 deletions(-)

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

