Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761Ab0IJMxT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 08:53:19 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:56074 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717Ab0IJMxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 08:53:18 -0400
Message-ID: <4C8A2A1A.1070806@atmel.com>
Date: Fri, 10 Sep 2010 14:52:42 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.2.9) Gecko/20100825 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        Andrew Victor <linux@maxim.org.za>
Subject: [GIT PULL]
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Can you please pull ARM/AT91 little fixes from:

  git://github.com/at91linux/linux-2.6-at91.git at91-fixes-for-linus

and receive the following changes:

Fabian Godehardt (1):
      AT91: SAM9G45 - add a separate clock entry for every single TC block

Nicolas Ferre (5):
      AT91: change dma resource index
      AT91: clock: peripheral clocks can have other parent than mck
      AT91: dm9000 initialization update
      AT91: at91sam9261ek board: remove warnings related to use of SPI or SD/MMC
      AT91: at91sam9261ek: remove C99 comments but keep information

 arch/arm/mach-at91/at91sam9g45.c         |   15 +++++++++++--
 arch/arm/mach-at91/at91sam9g45_devices.c |    6 ++--
 arch/arm/mach-at91/board-sam9261ek.c     |   31 ++++++++++++++++++-----------
 arch/arm/mach-at91/clock.c               |    3 +-
 4 files changed, 36 insertions(+), 19 deletions(-)

Thanks,
-- 
Nicolas Ferre

