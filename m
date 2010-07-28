Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328Ab0G1VXn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 17:23:43 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35943 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755518Ab0G1VXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 17:23:42 -0400
Subject: [GIT PULL] Regulator fixes for 2.6.35
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Jul 2010 22:23:37 +0100
Message-ID: <1280352217.3112.10.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following regulator fixes for 2.6.35.

Two are relatively small resource leakage fixes, whilst the tps6507x and
omap-l138-evm patches together fix a regulator voltage control bug on
the omap evm board.

Thanks

Liam

--- 

The following changes since commit b37fa16e78d6f9790462b3181602a26b5af36260:
  Linus Torvalds (1):
        Linux 2.6.35-rc6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lrg/voltage-2.6.git for-linus

Anuj Aggarwal (1):
      regulator: tps6507x: allow driver to use DEFDCDC{2,3}_HIGH register

Axel Lin (2):
      ab3100: fix off-by-one value range checking for voltage selector
      wm8350-regulator: fix wm8350_register_regulator error handling

Sekhar Nori (1):
      davinci: da850/omap-l138 evm: account for DEFDCDC{2,3} being tied high

 arch/arm/mach-davinci/board-da850-evm.c |    8 +++++++
 drivers/regulator/ab3100.c              |    4 +-
 drivers/regulator/tps6507x-regulator.c  |   36 +++++++++++++++++++++++++------
 drivers/regulator/wm8350-regulator.c    |    2 +-
 include/linux/regulator/tps6507x.h      |   32 +++++++++++++++++++++++++++
 5 files changed, 72 insertions(+), 10 deletions(-)
 create mode 100644 include/linux/regulator/tps6507x.h


