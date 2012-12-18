Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508Ab2LRVEN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 16:04:13 -0500
Received: from usmamail.tilera.com ([12.216.194.151]:22074 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345Ab2LRVEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 16:04:09 -0500
Message-ID: <50D0DA47.1050800@tilera.com>
Date: Tue, 18 Dec 2012 16:04:07 -0500
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] tile updates for 3.8
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile.git master

These are a smattering of minor changes from Tilera and other folks,
mostly in the ptrace area.

Chris Metcalf (3):
      tilegx: remove __init from pci fixup hook
      arch/tile: provide PT_FLAGS_COMPAT value in pt_regs
      arch/tile: clean up tile-specific PTRACE_SETOPTIONS

Simon Marchi (3):
      arch/tile: implement user_regset interface on tile
      arch/tile: implement arch_ptrace using user_regset on tile
      arch/tile: set CORE_DUMP_USE_REGSET on tile

Wei Yongjun (1):
      tile/PCI: use for_each_pci_dev to simplify the code

 arch/tile/include/asm/elf.h         |    2 +
 arch/tile/include/asm/ptrace.h      |    3 +-
 arch/tile/include/uapi/asm/ptrace.h |    8 +-
 arch/tile/kernel/pci.c              |    4 +-
 arch/tile/kernel/pci_gx.c           |    3 +-
 arch/tile/kernel/ptrace.c           |  140 ++++++++++++++++++++++++++++-------
 6 files changed, 126 insertions(+), 34 deletions(-)

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

