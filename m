Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884Ab2BQPCo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 10:02:44 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:8833 "EHLO sjogate2.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751038Ab2BQPCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 10:02:43 -0500
Message-ID: <4F3E6BFF.9030307@atmel.com>
Date: Fri, 17 Feb 2012 16:02:23 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120210 Thunderbird/10.0.1
MIME-Version: 1.0
To: Chris Ball <cjb@laptop.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-mmc@vger.kernel.org
CC: Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: [GIT PULL] at91 mmc fixes for 3.3-rc[45]
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

This is a couple of patches that fixes a sequence in atmel-mci during 
DMA/PDC detection + channel handling.

I also add the MAINTAINERS update and hand the SD/MMC drivers over to 
Ludovic Desroches who already made great efforts to enhance them.

You can find that the following changes since commit d65b4e98d7ea3038b767b70fe8be959b2913f16d:

  Linux 3.3-rc3 (2012-02-08 19:21:53 -0800)

are available in the git repository at:

  git://github.com/at91linux/linux-at91.git mmc-at91-fixes-for-3.3-rc4

for you to fetch changes up to 71055393e9e76a0c03f0b3b9d370a0ad2bae2763:

  MAINTAINERS: hand over atmel-mci (sd/mmc interface) (2012-02-17 15:40:18 +0100)

----------------------------------------------------------------
Ludovic Desroches (2):
      mmc: atmel-mci: don't use dma features when dma is present but there is no chan available
      mmc: atmel-mci: fix typo

Nicolas Ferre (1):
      MAINTAINERS: hand over atmel-mci (sd/mmc interface)

 MAINTAINERS                  |    4 ++--
 drivers/mmc/host/atmel-mci.c |   23 +++++++++++------------

Thanks a lot, best regards,
-- 
Nicolas Ferre
