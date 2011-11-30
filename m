Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757965Ab1K3QxP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 11:53:15 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:46708 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757945Ab1K3QxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 11:53:12 -0500
Message-ID: <4ED65F6D.4020402@atmel.com>
Date: Wed, 30 Nov 2011 17:53:01 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] at91 fixes for 3.2-rc4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

Here are a few fixes for AT91. I have noted 3.2-rc4 in the subject but it
is true that it can go in another -rc revision as I have seen your recent
pull request to Linus...

The following changes since commit caca6a03d365883564885f2c1da3e88dcf65d139:

  Linux 3.2-rc3 (2011-11-23 20:20:28 -0800)

are available in the git repository at:
  git://github.com/at91linux/linux-at91.git at91-fixes

Anders Darander (1):
      ARM: at91: Fix USB AT91 gadget registration

Christian Hitz (1):
      ARM: at91: fix NAND bus width decoding from system_rev

Jean-Christophe PLAGNIOL-VILLARD (1):
      ARM: at91: fix clock conid for atmel_tcb.1 on 9260/9g20

 arch/arm/mach-at91/at91rm9200_devices.c      |    2 +-
 arch/arm/mach-at91/at91sam9260.c             |    6 +++---
 arch/arm/mach-at91/at91sam9260_devices.c     |    2 +-
 arch/arm/mach-at91/at91sam9261_devices.c     |    2 +-
 arch/arm/mach-at91/at91sam9263_devices.c     |    2 +-
 arch/arm/mach-at91/include/mach/system_rev.h |    2 +-
 6 files changed, 8 insertions(+), 8 deletions(-)

Thanks, best regards,
-- 
Nicolas Ferre

