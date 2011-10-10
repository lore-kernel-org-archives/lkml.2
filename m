Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab1JJJrG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 05:47:06 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:5786 "EHLO sjogate2.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753097Ab1JJJrF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 05:47:05 -0400
Message-ID: <4E92BEE9.5090604@atmel.com>
Date: Mon, 10 Oct 2011 11:46:17 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>,
        Peter Korsgaard <jacmet@sunsite.dk>, herbert@gondor.hengli.com.au,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: [GIT PULL] at91: driver for Atmel true hardware random number generator
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

Here is a couple of patches for adding the True Random Number Generator
that can be find on some AT91SAM SoCs.
Herbert Xu told me that this material can go through the ARM SoC tree.

They may conflict with future work on at91 gpio that can be found on at91-next 
branch. We will recall you this during the "pull request" that we will send you 
for those bits...

The following changes since commit 976d167615b64e14bc1491ca51d424e2ba9a5e84:

  Linux 3.1-rc9 (2011-10-04 18:11:50 -0700)

are available in the git repository at:
git://github.com/at91linux/linux-at91.git for-arnd/at91-trng

Peter Korsgaard (2):
      ARM: at91: at91sam9g45: add trng clock and platform device
      hw_random: add driver for atmel true hardware random number generator

 arch/arm/mach-at91/at91sam9g45.c         |    7 ++
 arch/arm/mach-at91/at91sam9g45_devices.c |   29 ++++++
 drivers/char/hw_random/Kconfig           |   13 +++
 drivers/char/hw_random/Makefile          |    1 +
 drivers/char/hw_random/atmel-rng.c       |  158 ++++++++++++++++++++++++++++++
 5 files changed, 208 insertions(+), 0 deletions(-)
 create mode 100644 drivers/char/hw_random/atmel-rng.c

Thanks, cheers,
-- 
Nicolas Ferre
