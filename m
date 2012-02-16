Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435Ab2BPRJw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 12:09:52 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:41787 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751133Ab2BPRJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 12:09:50 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: linux-kernel@vger.kernel.org
Cc: Danny Kukawka <dkukawka@suse.de>, "David S. Miller" <davem@davemloft.net>,
        Bob Liu <bob.liu@analog.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Mike Frysinger <vapier@gentoo.org>, netdev@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Scott Jiang <scott.jiang@analog.com>,
        Sonic Zhang <sonic.zhang@analog.com>, Steven Miao <realmz6@gmail.com>,
        uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH v2 0/2] Part 3: handle random addresses on blackfin
Date: Thu, 16 Feb 2012 18:09:29 +0100
Message-Id: <1329412171-20704-1-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.8.3
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1329412190;7f03eeb1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The third part of my patch series to fix the handling of 
addr_assign_type for random MAC addresses. This contains the 
changes for the blackfin architecture and the adi ethernet
driver.

Please make sure you do a short compile test before pushing them.

Thanks!

Danny Kukawka (2):
  arch/blackfin: don't generate random mac in bfin_get_ether_addr()
  adi: adapt to eth_hw_addr_random() and changes in arch/blackfin

 arch/blackfin/mach-bf518/boards/ezbrd.c      |    3 ++-
 arch/blackfin/mach-bf518/boards/tcm-bf518.c  |    5 ++---
 arch/blackfin/mach-bf527/boards/ad7160eval.c |    3 ++-
 arch/blackfin/mach-bf527/boards/cm_bf527.c   |    5 ++---
 arch/blackfin/mach-bf527/boards/ezbrd.c      |    3 ++-
 arch/blackfin/mach-bf527/boards/ezkit.c      |    3 ++-
 arch/blackfin/mach-bf527/boards/tll6527m.c   |    3 ++-
 arch/blackfin/mach-bf537/boards/cm_bf537e.c  |    5 ++---
 arch/blackfin/mach-bf537/boards/cm_bf537u.c  |    5 ++---
 arch/blackfin/mach-bf537/boards/dnp5370.c    |    3 ++-
 arch/blackfin/mach-bf537/boards/pnav10.c     |    5 ++---
 arch/blackfin/mach-bf537/boards/stamp.c      |    3 ++-
 arch/blackfin/mach-bf537/boards/tcm_bf537.c  |    5 ++---
 drivers/net/ethernet/adi/bfin_mac.c          |   15 +++++++++------
 drivers/net/ethernet/adi/bfin_mac.h          |    2 +-
 15 files changed, 36 insertions(+), 32 deletions(-)

-- 
1.7.8.3

