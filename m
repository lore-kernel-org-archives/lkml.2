Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757123Ab2DTDvI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 23:51:08 -0400
Received: from dalsmrelay2.nai.com ([205.227.136.216]:63531 "EHLO
	dalsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab2DTDvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 23:51:06 -0400
Date: Fri, 20 Apr 2012 13:47:16 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-ID: <201204200347.q3K3lGJv011042@goober.corp.nai.org>
CC: <gerg@uclinux.org>, <linux-kernel@vger.kernel.org>,
        <linux-m68k@vger.kernel.org>, <geert@linux-m68k.org>
Subject: [git pull] m68knommu arch fixes for 3.4
To: <torvalds@linux-foundation.org>
X-Mailer: mail (GNU Mailutils 2.1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Can you please pull the m68knommu git tree:

  git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git for-linus

It contains four fixes for 3.4. Two fix and clean up compilation for the
nommu 68x328 CPU targets. The other two fix the platform definition and
multi-function pin setup of the second eth interface on the ColdFire
5275 SoC.

Thanks
Greg



The following changes since commit e816b57a337ea3b755de72bec38c10c864f23015:
  Linus Torvalds (1):
        Linux 3.4-rc3

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git for-linus

Greg Ungerer (4):
      m68knommu: remove the unused bootlogo.h processing for 68EZ328 and 68VZ328
      m68knommu: move and fix the 68VZ328 platform bootlogo.h
      m68knommu: fix id number for second eth device on 5275 ColdFire
      m68knommu: make sure 2nd FEC eth interface pins are enabled on 5275 ColdFire

 arch/m68k/configs/m5275evb_defconfig               |    1 -
 arch/m68k/platform/527x/config.c                   |    2 --
 arch/m68k/platform/68EZ328/Makefile                |    6 ------
 arch/m68k/platform/68VZ328/Makefile                |    9 ++-------
 arch/m68k/platform/{68EZ328 => 68VZ328}/bootlogo.h |    2 +-
 arch/m68k/platform/coldfire/device.c               |    2 +-
 6 files changed, 4 insertions(+), 18 deletions(-)
 rename arch/m68k/platform/{68EZ328 => 68VZ328}/bootlogo.h (99%)
