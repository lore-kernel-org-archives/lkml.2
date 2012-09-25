Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773Ab2IYIZO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 04:25:14 -0400
Received: from antcom.de ([188.40.178.216]:41048 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753057Ab2IYIZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 04:25:11 -0400
Message-ID: <50616A64.8040600@antcom.de>
Date: Tue, 25 Sep 2012 10:25:08 +0200
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
Subject: [GIT PULL] ARM: LPC32xx: DTS updates #2
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd and Olof,

this is a second round of mach-lpc32xx specific updates for 3.7, below
the dts branch. Only one patch for adjusting phy3250.dts.

Thanks,

Roland


The following changes since commit 25b3ab6c7e39e42245d98c27d25d9902baec7b65:

  ARM: LPC32xx: Extend dts for EA3250 board (2012-09-06 11:40:48 +0200)

are available in the git repository at:

  git://git.antcom.de/linux-2.6.git lpc32xx/dts

for you to fetch changes up to 07c7e12ca7e32e942d2c42dd67329c5fc3886b07:

  ARM: LPC32xx: LED fix in PHY3250 DTS file (2012-09-25 10:11:41 +0200)

----------------------------------------------------------------
Roland Stigge (1):
      ARM: LPC32xx: LED fix in PHY3250 DTS file

 arch/arm/boot/dts/phy3250.dts |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)
