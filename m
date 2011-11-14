Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586Ab1KNJzn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 04:55:43 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:14699 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368Ab1KNJzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 04:55:41 -0500
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bh8275dhz2ei87h2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPVD:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Bob Liu <lliubbo@gmail.com>
To: <torvalds@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <uclinux-dist-devel@blackfin.uclinux.org>,
        <vapier@gentoo.org>, <sonic.zhang@analog.com>
Subject: [GIT PULL]blackfin fixes for 3.2-rc2
Date: Mon, 14 Nov 2011 17:56:20 +0800
Message-ID: <1321264580-18337-1-git-send-email-lliubbo@gmail.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the for-linus branch of my blackfin git tree.
It has two small fixes since rc1. One fixed a compile warning, the other
is needed since tty/serail layers have already been merged.

The following changes since commit 7f80850d3f9fd8fda23a317044aef3a6bafab06b:
  Linus Torvalds (1):
        Merge branch 'rmobile-fixes-for-linus' of git://github.com/pmundt/linux-sh

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lliubbo/blackfin.git for-linus

Lars-Peter Clausen (1):
      blackfin: Fixup export.h includes

Sonic Zhang (1):
      Blackfin: add serial TX IRQ in individual platform resource

 arch/blackfin/include/asm/bfin_serial.h      |    2 +
 arch/blackfin/mach-bf518/boards/ezbrd.c      |   14 +++++++++++-
 arch/blackfin/mach-bf518/boards/tcm-bf518.c  |   14 +++++++++++-
 arch/blackfin/mach-bf527/boards/ad7160eval.c |   14 +++++++++++-
 arch/blackfin/mach-bf527/boards/cm_bf527.c   |   16 ++++++++++++--
 arch/blackfin/mach-bf527/boards/ezbrd.c      |   16 ++++++++++++--
 arch/blackfin/mach-bf527/boards/ezkit.c      |   14 +++++++++++-
 arch/blackfin/mach-bf527/boards/tll6527m.c   |   14 +++++++++++-
 arch/blackfin/mach-bf533/boards/H8606.c      |    7 +++++-
 arch/blackfin/mach-bf533/boards/blackstamp.c |    7 +++++-
 arch/blackfin/mach-bf533/boards/cm_bf533.c   |    7 +++++-
 arch/blackfin/mach-bf533/boards/ezkit.c      |    7 +++++-
 arch/blackfin/mach-bf533/boards/ip0x.c       |    7 +++++-
 arch/blackfin/mach-bf533/boards/stamp.c      |    7 +++++-
 arch/blackfin/mach-bf537/boards/cm_bf537e.c  |   16 ++++++++++++--
 arch/blackfin/mach-bf537/boards/cm_bf537u.c  |   16 ++++++++++++--
 arch/blackfin/mach-bf537/boards/dnp5370.c    |   16 ++++++++++++--
 arch/blackfin/mach-bf537/boards/minotaur.c   |   14 +++++++++++-
 arch/blackfin/mach-bf537/boards/pnav10.c     |   15 ++++++++++++-
 arch/blackfin/mach-bf537/boards/stamp.c      |   16 ++++++++++++--
 arch/blackfin/mach-bf537/boards/tcm_bf537.c  |   16 ++++++++++++--
 arch/blackfin/mach-bf538/boards/ezkit.c      |   21 ++++++++++++++++--
 arch/blackfin/mach-bf548/boards/cm_bf548.c   |   28 ++++++++++++++++++++++---
 arch/blackfin/mach-bf548/boards/ezkit.c      |   28 ++++++++++++++++++++++---
 arch/blackfin/mach-bf561/boards/acvilon.c    |    7 +++++-
 arch/blackfin/mach-bf561/boards/cm_bf561.c   |    7 +++++-
 arch/blackfin/mach-bf561/boards/ezkit.c      |    7 +++++-
 arch/blackfin/mach-bf561/boards/tepla.c      |    7 +++++-
 28 files changed, 304 insertions(+), 56 deletions(-)

