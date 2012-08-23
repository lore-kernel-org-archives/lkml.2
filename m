Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313Ab2HWO6t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 10:58:49 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:40650 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457Ab2HWO6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 10:58:45 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Chris Zankel <chris@zankel.net>, "3.2.x.." <stable@vger.kernel.org>,
        Chen Liqin <liqin.chen@sunplusct.com>, Lennox Wu <lennox.wu@gmail.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, Parisc <linux-parisc@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        m68k <linux-m68k@vger.kernel.org>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Cris <linux-cris-kernel@axis.com>, Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, alpha <linux-alpha@vger.kernel.org>,
        Michael Cree <mcree@orcon.net.nz>
Subject: [PATCH 00/11] rcu: Add missing RCU idle APIs on idle loop v2
Date: Thu, 23 Aug 2012 16:58:24 +0200
Message-Id: <1345733915-20040-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Changes since v1:

- Fixed preempt handling in alpha idle loop
- added ack from Geert
- fixed stable email address, sorry :-/

This time I built tested everywhere but: h8300 (compiler internal error),
and mn10300, parisc, score (cross compilers not available in
ftp://ftp.kernel.org/pub/tools/crosstool/files/bin/x86_64/4.6.3/)

For testing, you can pull from:

git://github.com/fweisbec/linux-dynticks.git
	rcu/idle-fix-v2 

Thanks.

Frederic Weisbecker (11):
  alpha: Fix preemption handling in idle loop
  alpha: Add missing RCU idle APIs on idle loop
  cris: Add missing RCU idle APIs on idle loop
  frv: Add missing RCU idle APIs on idle loop
  h8300: Add missing RCU idle APIs on idle loop
  m32r: Add missing RCU idle APIs on idle loop
  m68k: Add missing RCU idle APIs on idle loop
  mn10300: Add missing RCU idle APIs on idle loop
  parisc: Add missing RCU idle APIs on idle loop
  score: Add missing RCU idle APIs on idle loop
  xtensa: Add missing RCU idle APIs on idle loop

 arch/alpha/kernel/process.c   |    6 +++++-
 arch/alpha/kernel/smp.c       |    1 +
 arch/cris/kernel/process.c    |    3 +++
 arch/frv/kernel/process.c     |    3 +++
 arch/h8300/kernel/process.c   |    3 +++
 arch/m32r/kernel/process.c    |    3 +++
 arch/m68k/kernel/process.c    |    3 +++
 arch/mn10300/kernel/process.c |    3 +++
 arch/parisc/kernel/process.c  |    3 +++
 arch/score/kernel/process.c   |    4 +++-
 arch/xtensa/kernel/process.c  |    3 +++
 11 files changed, 33 insertions(+), 2 deletions(-)

-- 
1.7.5.4

