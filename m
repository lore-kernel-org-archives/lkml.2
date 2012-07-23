Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920Ab2GWUdT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 16:33:19 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:61616 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754874Ab2GWUdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 16:33:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        arm@kernel.org
Subject: [GIT PULL 04/15] arm-soc: samsung dma changes
Date: Mon, 23 Jul 2012 22:32:30 +0200
Message-Id: <1343075561-17446-5-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1343075561-17446-1-git-send-email-arnd@arndb.de>
References: <1343075561-17446-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:gFM819uogD6xXjhrHiwdG3uFUKqjA1+jedHqOwWx4ME
 cSnWa/dXz9dOWGtgCHhBN3c1KxbtGUbxfiva2IIz5X85Yj7HoO
 jJ7u9Pkfmxd346Hl+eevqZyykEQWgo88tUlM76KaxLb+uBc4ga
 XeZyPykWPhzeGdFAKBUAlx7+sIP4f08dJtO2bUe/8Mbol6l356
 k1cOCkE+g7rOzwwgreUkpW0aiKzWakv7io4byqbMbw0nXjfwLj
 Rn3RZnSIdTGGOl0wU9CFaCqBrCUjTNZJz/Ex6pZuJTcQsozUJA
 ST8Oqtre5/neCL0iNkqWbJZ8qJTOWZ6cZdz1+CzhzP6Q1DtNlg
 ZGI0sPaPvlXyaioq9jABGBFLlxjTQ1j9QLOL8tyyK
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit bd0a521e88aa7a06ae7aabaed7ae196ed4ad867a:

  Linux 3.5-rc6 (2012-07-07 17:23:56 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git next/dma

for you to fetch changes up to 31dfec74c0dc49521b2e17543ff9dd9dd0221702:

  Merge branch 'next/devel-dma-ops' of git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung into next/dma (2012-07-10 14:12:05 +0200)

----------------------------------------------------------------

arm-soc: samsung dma changes

Some platforms are not yet converted to use the dmaengine framework,
including some of the samsung SoCs. In the meantime, we treat this
as platform code and merge the patches through the arm-soc tree.

----------------------------------------------------------------

Arnd Bergmann (2):
      Merge branch 'next/devel-dma-ops' of git://git.kernel.org/.../kgene/linux-samsung into next/dma
      Merge branch 'next/dma' into for-next

Boojin Kim (3):
      ARM: SAMSUNG: Add config() function in DMA common operations
      spi/s3c64xx: Add the use of DMA config operation
      ASoC: follow the updated samsung DMA common operations

Sachin Kamat (1):
      ARM: SAMSUNG: Fix compiler warning in dma-ops.c file

 arch/arm/plat-samsung/dma-ops.c              |   76 ++++++++++++++------------
 arch/arm/plat-samsung/include/plat/dma-ops.h |   20 ++++---
 arch/arm/plat-samsung/s3c-dma-ops.c          |   39 +++++++------
 drivers/spi/spi-s3c64xx.c                    |   33 ++++++-----
 sound/soc/samsung/dma.c                      |   18 +++---
 5 files changed, 105 insertions(+), 81 deletions(-)
