Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844Ab1HPN4t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 09:56:49 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:20117 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659Ab1HPN4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 09:56:46 -0400
Message-ID: <4E4A7713.1070902@atmel.com>
Date: Tue, 16 Aug 2011 15:56:35 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.2.18) Gecko/20110616 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: "Koul, Vinod" <vinod.koul@intel.com>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>
CC: "Williams, Dan J" <dan.j.williams@intel.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] dmaengine: at_hdmac fixes for next
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vinod,

Please pull from:

  git://github.com/at91linux/linux-2.6-at91.git nfe/sdma_at_hdmac

to receive latest updates for the Atmel at_hdmac dmaengine driver. Those changes are made on top of current linus' git tree (v3.1-rc2-59-g5bad33c).
The patches below have been discussed on the linux-arm-kernel mailing-list.

Thanks,

Nicolas Ferre (4):
      dmaengine: at_hdmac: replace spin_lock* with irqsave variants
      dmaengine: at_hdmac: improve power management routines
      dmaengine: at_hdmac: add wrappers for testing channel state
      dmaengine: at_hdmac: fix way to specify cyclic capability

 drivers/dma/at_hdmac.c      |  159 +++++++++++++++++++++++++++++++++---------
 drivers/dma/at_hdmac_regs.h |   24 +++++++
 2 files changed, 149 insertions(+), 34 deletions(-)

-- 
Nicolas Ferre

