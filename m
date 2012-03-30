Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760425Ab2C3BUz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 21:20:55 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:64525 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760124Ab2C3BUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 21:20:46 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 29 Mar 2012 19:20:25 -0600
X-Google-Sender-Auth: I7zrqdvonwp0LIrnR1eIQ-Lv1V4
Message-ID: <CACxGe6sY5wX4+_d4VhaY=grPe+DgATgrR5162cvwhK9uZ_K5Ww@mail.gmail.com>
Subject: [GIT PULL] devicetree documentation updates
To: Linus Torvalds <torvalds@linux-foundation.org>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull these documentation changes for devicetree usage.

Cheers,
g.

The following changes since commit 735e941caa9a35f933297af0ab1e0ad6447411c4:

  Merge tag 'common-clk-api' of
git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc (2012-03-28
12:38:06 -0700)

are available in the git repository at:


  git://git.secretlab.ca/git/linux-2.6 tags/devicetree-for-linus

for you to fetch changes up to 31134efc681a5440e2b952eed3bf9a5306a95062:

  dt: Linux DT usage model documentation (2012-03-29 19:13:50 -0600)

----------------------------------------------------------------
Devicetree documentation update for v3.4

----------------------------------------------------------------
Grant Likely (1):
      dt: Linux DT usage model documentation

Jamie Lentin (1):
      mtd: Move fdt partition documentation to a seperate file

 .../devicetree/bindings/mtd/arm-versatile.txt      |    4 +-
 .../devicetree/bindings/mtd/atmel-dataflash.txt    |    3 +
 .../devicetree/bindings/mtd/fsl-upm-nand.txt       |    4 +
 .../devicetree/bindings/mtd/gpio-control-nand.txt  |    3 +
 .../devicetree/bindings/mtd/mtd-physmap.txt        |   23 +-
 .../devicetree/bindings/mtd/partition.txt          |   38 ++
 Documentation/devicetree/usage-model.txt           |  412 ++++++++++++++++++++
 7 files changed, 464 insertions(+), 23 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mtd/partition.txt
 create mode 100644 Documentation/devicetree/usage-model.txt


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
