Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab2GTMIr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 08:08:47 -0400
Received: from antcom.de ([188.40.178.216]:49422 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752560Ab2GTMIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 08:08:43 -0400
Message-ID: <50094A4A.8090303@antcom.de>
Date: Fri, 20 Jul 2012 14:08:42 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: arm@kernel.org
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Pereira da Silva <aletes.xgr@gmail.com>
Subject: [GIT PULL] ARM: LPC32xx: DTS file updates
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd and Olof,

this is a late addition to LPC32xx DTS files for v3.6. Branch lpc32xx/dts2,
building upon previously posted lpc32xx/dts.

Thanks,

Roland


The following changes since commit 7bb71a6c3241b8e20b54fe9978cc9af5eddfd428:

  ARM: LPC32xx: Update DTS file for EA3250 board (2012-07-01 21:04:17 +0200)

are available in the git repository at:

  git://git.antcom.de/linux-2.6.git lpc32xx/dts2

for you to fetch changes up to de639854441af37fc88a72daab5842045d518944:

  ARM: LPC32xx: Add PWM to base dts file (2012-07-20 13:33:09 +0200)

----------------------------------------------------------------
Alexandre Pereira da Silva (1):
      ARM: LPC32xx: Add PWM to base dts file

 arch/arm/boot/dts/lpc32xx.dtsi |    5 +++++
 1 file changed, 5 insertions(+)
