Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232Ab2GTMHv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 08:07:51 -0400
Received: from antcom.de ([188.40.178.216]:49364 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752560Ab2GTMHs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 08:07:48 -0400
Message-ID: <50094A0E.4070006@antcom.de>
Date: Fri, 20 Jul 2012 14:07:42 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: arm@kernel.org
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Pereira da Silva <aletes.xgr@gmail.com>
Subject: [GIT PULL] ARM: LPC32xx: Core updates
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd and Olof,

this LPC32xx core update (branch lpc32xx/core2) builds upon the
previously provided lpc32xx/core-fixes. Basically including PWM support
(for the PWM driver from Alexandre already in the pwm tree), and
CPU ID.

Thanks,

Roland


The following changes since commit 8ba85f8bffdfbac98dac8630406f7d020103db70:

  ARM: LPC32xx: Adjust to pl08x DMA interface changes (2012-07-12 14:25:37 +0200)

are available in the git repository at:

  git://git.antcom.de/linux-2.6.git lpc32xx/core2

for you to fetch changes up to c49a18308669a7c1bd61ddd4f575a88d49b0b852:

  ARM: LPC32xx: Add PWM support (2012-07-20 14:01:51 +0200)

----------------------------------------------------------------
Alexandre Pereira da Silva (3):
      ARM: LPC32xx: Set system serial based on cpu unique id
      ARM: LPC32xx: Add PWM clock
      ARM: LPC32xx: Add PWM support

 arch/arm/Kconfig               |    1 +
 arch/arm/mach-lpc32xx/clock.c  |   14 ++++++++++++++
 arch/arm/mach-lpc32xx/common.c |   10 ++++++++--
 3 files changed, 23 insertions(+), 2 deletions(-)
