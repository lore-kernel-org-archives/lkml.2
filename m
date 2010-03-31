Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757709Ab0CaGXi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 02:23:38 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:63819 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757328Ab0CaGXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 02:23:36 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 31 Mar 2010 00:18:03 -0600
X-Google-Sender-Auth: 0b4639c896a5bee9
Message-ID: <p2ifa686aa41003302318n934b8908v295ccf5c1ae44edc@mail.gmail.com>
Subject: [git pull] Device tree and PowerPC bug fixes
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Roman Fietze <roman.fietze@telemotive.de>,
       Timur Tabi <timur@freescale.com>,
       Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Can you please pull the following branch?  It contains two simple bug
fixes that should go into 2.6.34, plus a zero-risk documentation
update.

Thanks,
g.

The following changes since commit b72c40949b0f04728f2993a1434598d3bad094ea:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../jbarnes/pci-2.6

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 merge

Jason Gunthorpe (1):
      of/flattree: Fix unhandled OF_DT_NOP tag when unflattening the device tree

Roman Fietze (1):
      powerpc/5200: in lpbfifo, flag DMA irqs as enabled after requesting them

Timur Tabi (1):
      powerpc/fsl: add device tree binding for QE firmware

 .../powerpc/dts-bindings/fsl/cpm_qe/qe.txt         |   54 ++++++++++++++++++++
 arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c      |    2 +
 drivers/of/fdt.c                                   |    7 ++-
 3 files changed, 61 insertions(+), 2 deletions(-)


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
