Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757040Ab0DEXym (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 19:54:42 -0400
Received: from sh.osrg.net ([192.16.179.4]:47002 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756757Ab0DEXyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 19:54:38 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: akpm@linux-foundation.org
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org
Subject: [PATCH -mm 00/12] use asm-generic/scatterlist.h on every architecture (the second half)
Date: Tue,  6 Apr 2010 08:52:35 +0900
Message-Id: <1270511567-18567-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.7.0
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 06 Apr 2010 08:54:33 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the architectures are converted to use
asm-generic/scatterlist.h. The first half is:

http://marc.info/?l=linux-kernel&m=127039230002523&w=2

=
 arch/alpha/include/asm/scatterlist.h      |    4 +--
 arch/arm/include/asm/scatterlist.h        |    3 --
 arch/avr32/include/asm/scatterlist.h      |   20 +-------------
 arch/blackfin/include/asm/scatterlist.h   |   22 +---------------
 arch/cris/include/asm/scatterlist.h       |   17 +-----------
 arch/frv/include/asm/scatterlist.h        |   40 +----------------------------
 arch/h8300/include/asm/scatterlist.h      |   12 +--------
 arch/ia64/include/asm/scatterlist.h       |    4 +-
 arch/m32r/include/asm/scatterlist.h       |   15 +----------
 arch/m68k/include/asm/scatterlist.h       |   16 +-----------
 arch/microblaze/include/asm/scatterlist.h |    4 +-
 arch/mips/include/asm/scatterlist.h       |   22 +---------------
 arch/mn10300/include/asm/scatterlist.h    |   39 +---------------------------
 arch/parisc/Kconfig                       |    3 ++
 arch/parisc/include/asm/scatterlist.h     |   20 +-------------
 arch/powerpc/include/asm/scatterlist.h    |    1 +
 arch/sparc/include/asm/scatterlist.h      |    5 ++-
 arch/x86/include/asm/scatterlist.h        |    5 ++-
 arch/xtensa/include/asm/scatterlist.h     |   23 +----------------
 include/asm-generic/scatterlist.h         |    2 -
 20 files changed, 27 insertions(+), 250 deletions(-)


