Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377Ab1GROZH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 10:25:07 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:56281 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393Ab1GROZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 10:25:04 -0400
From: Borislav Petkov <bp@amd64.org>
To: Tony Luck <tony.luck@intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: EDAC devel <linux-edac@vger.kernel.org>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 0/2] x86, MCE: Use MCE decoder notifier chain
Date: Mon, 18 Jul 2011 16:24:44 +0200
Message-Id: <1310999086-30870-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Hi Mauro, Tony,

the following two patches convert i7core_edac to use the MCE decoder
notifier chain, thus getting rid of the custom edac_mce hook. There
should be no functionality change following from this along with a nice
diffstat of removing ca 100 lines.

The patches are ontop of the latest tip/ras/core and are available at

git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git fix-mce-logging

I'd like to ask you guys to please give them a run to make sure I
haven't broken i7core_edac.

Thanks.

 arch/x86/kernel/cpu/mcheck/mce.c |   18 ++++-------
 drivers/edac/Kconfig             |    3 --
 drivers/edac/Makefile            |    1 -
 drivers/edac/edac_mce.c          |   61 --------------------------------------
 drivers/edac/i7core_edac.c       |   51 +++++++++++++++----------------
 include/linux/edac_mce.h         |   31 -------------------
 6 files changed, 31 insertions(+), 134 deletions(-)


