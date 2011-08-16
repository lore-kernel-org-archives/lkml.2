Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392Ab1HPPgt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 11:36:49 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:24386 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621Ab1HPPgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 11:36:48 -0400
Message-ID: <4E4A8E73.7050705@atmel.com>
Date: Tue, 16 Aug 2011 17:36:19 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.2.18) Gecko/20110616 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Chris Ball <cjb@laptop.org>, linux-mmc@vger.kernel.org,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] mmc: atmel rework for next
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

Please pull from:

git://github.com/at91linux/linux-2.6-at91.git nfe/mmc_atmel

This is a series that reworks the atmel-mci driver for a future merge of both at91_mci and atmel-mci drivers. Those patches have been discussed on the mailing-list.
I added a tiny at91_mci patch also sent last week.

Those changes are made on top of current linus' git tree (v3.1-rc2-64-g688d1b3).

Thanks.

Ludovic Desroches (8):
      mmc: atmel-mci: change namespace
      mmc: atmel-mci: change atmci_readl and atmci_writel macros
      mmc: atmel-mci: indentation
      mmc: atmel-mci: add pdc support and runtime capabilities detection
      mmc: atmel-mci: change atmci_start_command to atmci_send_command
      mmc: atmel-mci: use ATMEL_PDC_SCND_BUF_OFF instead of a literal value
      mmc: atmel-mci: correct sg buffer size evaluation
      mmc: atmel-mci: fix a potential issue about pending PDC interrupts

Nicolas Ferre (1):
      mmc: at91_mci: remove the use of irq_to_gpio

 arch/arm/mach-at91/at91sam9260_devices.c |    2 +-
 drivers/mmc/host/at91_mci.c              |    6 +-
 drivers/mmc/host/atmel-mci-regs.h        |  220 +++++----
 drivers/mmc/host/atmel-mci.c             |  823 ++++++++++++++++++++----------
 include/linux/atmel-mci.h                |    4 +-
 include/linux/atmel_pdc.h                |    2 +
 6 files changed, 685 insertions(+), 372 deletions(-)



-- 
Nicolas Ferre

