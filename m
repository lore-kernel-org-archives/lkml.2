Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629Ab0DDOoi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 10:44:38 -0400
Received: from sh.osrg.net ([192.16.179.4]:56598 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754382Ab0DDOoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 10:44:25 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp, arnd@arndb.de
Subject: [PATCH -mm 0/5] use asm-generic/scatterlist.h on every architecture
Date: Sun,  4 Apr 2010 23:25:48 +0900
Message-Id: <1270391153-17519-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.7.0
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sun, 04 Apr 2010 23:44:13 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the first half of the attempt to use asm-generic/scatterlist.h
on every architecture.

There are only two ways to define scatterlist structure. So it's easy
to convert every architecture to use asm-generic/scatterlist.h.

=
 arch/alpha/Kconfig                        |    3 +++
 arch/alpha/include/asm/scatterlist.h      |   21 +++------------------
 arch/arm/include/asm/scatterlist.h        |   20 ++------------------
 arch/ia64/Kconfig                         |    3 +++
 arch/microblaze/include/asm/scatterlist.h |    2 ++
 arch/powerpc/Kconfig                      |    3 +++
 arch/powerpc/include/asm/scatterlist.h    |   29 +----------------------------
 arch/s390/include/asm/scatterlist.h       |    2 ++
 arch/score/include/asm/scatterlist.h      |    2 ++
 arch/sh/Kconfig                           |    3 +++
 arch/sparc/Kconfig                        |    3 +++
 arch/sparc/include/asm/scatterlist.h      |    2 +-
 arch/x86/Kconfig                          |    3 +++
 include/asm-generic/scatterlist.h         |   15 ++++-----------
 14 files changed, 35 insertions(+), 76 deletions(-)


