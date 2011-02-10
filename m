Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675Ab1BJRPV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 12:15:21 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:44566 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820Ab1BJRPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 12:15:20 -0500
From: Borislav Petkov <bp@amd64.org>
To: <linux-edac@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>,
        Ingo Molnar <mingo@elte.hu>, Greg Kroah-Hartman <greg@kroah.com>
Subject: [PATCH 00/30] amd64_edac: Add Bulldozer support
Date: Thu, 10 Feb 2011 18:15:03 +0100
Message-Id: <1297358133-14320-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Hi all,

the following patchset that adds support for our upcoming F15h CPUs.
Besides adding a new family support, it cleans up a lot in the driver
and the diffstat says it all:

 arch/x86/kernel/amd_nb.c      |    2 +-
 drivers/edac/amd64_edac.c     | 1412 +++++++++++++++++++----------------------
 drivers/edac/amd64_edac.h     |  357 ++++-------
 drivers/edac/amd64_edac_inj.c |    8 +-
 drivers/edac/edac_mc_sysfs.c  |   26 +-
 drivers/edac/mce_amd.c        |    8 +-
 drivers/edac/mce_amd.h        |   28 +-
 include/linux/pci_ids.h       |    2 +-
 8 files changed, 825 insertions(+), 1018 deletions(-)

@Greg/@Ingo: Guys, let me know if patch 27/30 should be rerouted over
your trees or would you rather like to ACK it?

Any comments/suggestions are welcome.

Thanks.
