Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758453Ab0FOVDk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 17:03:40 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:38092 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535Ab0FOVDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 17:03:38 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 15 Jun 2010 14:55:56 -0600
X-Google-Sender-Auth: E8vAbuUilKRbxW6eARF15kQpVX8
Message-ID: <AANLkTikBVzZB9M-l67dF2V5Z0ctTJmEyRBvzVES3FZWH@mail.gmail.com>
Subject: [git pull] OF and powerpc 5200 bug fixes.
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michael Ellerman <michael@ellerman.id.au>,
       Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are some device tree and mpc5200 related bug fixes plus a
documentation update for 2.6.35.

Thanks,
g.

The following changes since commit 7e27d6e778cd87b6f2415515d7127eba53fe5d02:
  Linus Torvalds (1):
        Linux 2.6.35-rc3

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 merge

Dmitry Eremin-Solenikov (3):
      powerpc/5200: add lite5200 onboard I2C eeprom and flash
      powerpc/5200: fix oops during going to standby
      powerpc/5200: fix lite5200 ethernet phy address

Grant Likely (2):
      maintainers: Add git trees for SPI and device tree
      powerpc/5200: Fix build error in sound code.

Michael Ellerman (1):
      of: Drop properties with "/" in their name

 MAINTAINERS                              |    2 ++
 arch/powerpc/boot/dts/lite5200.dts       |   28 ++++++++++++++++++++++++++--
 arch/powerpc/boot/dts/lite5200b.dts      |    5 +++++
 arch/powerpc/platforms/52xx/mpc52xx_pm.c |   11 ++++++++++-
 fs/proc/proc_devtree.c                   |    3 +++
 sound/soc/fsl/mpc5200_dma.h              |    2 +-
 6 files changed, 47 insertions(+), 4 deletions(-)


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
