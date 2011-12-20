Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447Ab1LTIY1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 03:24:27 -0500
Received: from linux-sh.org ([111.68.239.195]:46782 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751610Ab1LTIYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 03:24:21 -0500
Date: Tue, 20 Dec 2011 17:24:16 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] rmobile fixes for 3.2-rc7
Message-ID: <20111220082416.GA21727@linux-sh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

        git://github.com/pmundt/linux-sh.git rmobile-fixes-for-linus

Which contains:

Magnus Damm (5):
      ARM: mach-shmobile: Kota2 PINT fix
      ARM: mach-shmobile: Kota2 GIC Sparse IRQ fix
      ARM: mach-shmobile: Kota2 TPU LED platform data
      ARM: mach-shmobile: AG5EVM GIC Sparse IRQ fix
      ARM: mach-shmobile: SH73A0 external Ethernet fix

 arch/arm/mach-shmobile/board-ag5evm.c |    1 +
 arch/arm/mach-shmobile/board-kota2.c  |  139 ++++++++++++++++++++++++++++----
 arch/arm/mach-shmobile/clock-sh73a0.c |   18 ++++-
 3 files changed, 139 insertions(+), 19 deletions(-)
