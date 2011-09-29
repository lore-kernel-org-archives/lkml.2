Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757486Ab1I2TbI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 15:31:08 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:57331 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420Ab1I2TbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 15:31:06 -0400
Date: Thu, 29 Sep 2011 15:31:02 -0400 (EDT)
Message-Id: <20110929.153102.2109075340222189134.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 29 Sep 2011 12:31:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The firmware exec bit problem took nearly 2 weeks to find, not
fun.

Please pull, thanks a lot!

The following changes since commit d5767c53535ac79758084773418e0ad186aba4a2:

  bootup: move 'usermodehelper_enable()' to the end of do_basic_setup() (2011-09-28 10:23:44 -0700)

are available in the git repository at:
  git://github.com/davem330/sparc.git master

David S. Miller (3):
      sparc64: Future proof Niagara cpu detection.
      sparc: Make '-p' boot option meaningful again.
      sparc64: Force the execute bit in OpenFirmware's translation entries.

Mathias Krause (1):
      sparc, exec: remove redundant addr_limit assignment

 arch/sparc/include/asm/spitfire.h |    2 ++
 arch/sparc/include/asm/xor_64.h   |    4 +++-
 arch/sparc/kernel/cpu.c           |   12 ++++++++++++
 arch/sparc/kernel/cpumap.c        |    2 ++
 arch/sparc/kernel/head_64.S       |   25 ++++++++++++++++++++++---
 arch/sparc/kernel/process_32.c    |    3 +--
 arch/sparc/kernel/process_64.c    |    3 ---
 arch/sparc/kernel/setup_32.c      |    2 +-
 arch/sparc/kernel/setup_64.c      |   18 +++++++++++++-----
 arch/sparc/mm/init_64.c           |    5 +++++
 10 files changed, 61 insertions(+), 15 deletions(-)
