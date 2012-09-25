Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab2IYI1N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 04:27:13 -0400
Received: from antcom.de ([188.40.178.216]:45784 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753764Ab2IYI1C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 04:27:02 -0400
Message-ID: <50616AD5.3010104@antcom.de>
Date: Tue, 25 Sep 2012 10:27:01 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: arm@kernel.org
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Pereira da Silva <aletes.xgr@gmail.com>,
        Kevin Wells <kevin.wells@nxp.com>,
        Srinivas Bakki <srinivas.bakki@nxp.com>
Subject: [GIT PULL] ARM: LPC32xx: Core updates #2
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd and Olof,

this is a second round of mach-lpc32xx specific updates for 3.7. Below,
the core branch.

Thanks,

Roland


The following changes since commit 7a5deff68f9e0a1db170ac9dd3b2b4aaddc1b80c:

  ARM: LPC32xx: Remove board specific GPIO init (2012-09-06 11:39:29 +0200)

are available in the git repository at:

  git://git.antcom.de/linux-2.6.git lpc32xx/core

for you to fetch changes up to 8e4b97e3b8fd6a7f86bf8b38e7975549f2c48a78:

  ARM: LPC32xx: Support GPI 28 (2012-09-25 10:19:23 +0200)

----------------------------------------------------------------
Roland Stigge (3):
      ARM: LPC32xx: Board cleanup
      ARM: LPC32xx: Platform update for devicetree completion of spi-pl022
      ARM: LPC32xx: Support GPI 28

 arch/arm/mach-lpc32xx/include/mach/gpio-lpc32xx.h |    2 +-
 arch/arm/mach-lpc32xx/phy3250.c                   |   22 ++-------------------
 2 files changed, 3 insertions(+), 21 deletions(-)
