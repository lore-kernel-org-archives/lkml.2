Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209Ab1KDD46 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 23:56:58 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:38927 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932093Ab1KDD45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 23:56:57 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 3 Nov 2011 23:56:33 -0400
X-Google-Sender-Auth: xhpqbQQ2sdl2zwcuM_4lc0VFu_U
Message-ID: <CACxGe6t-xaH4U9F7uGOabYD-KKSHZNyQ3Ds036FhubScqR=vGQ@mail.gmail.com>
Subject: [GIT PULL] A few more device tree changes
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, Olof Johansson <olof@lixom.net>,
        Rob Herring <robherring2@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

A few more for 3.2.  Nothing exciting here.

g.

The following changes since commit d6748066ad0e8b2514545998f8367ebb3906f299:

  Merge branch 'upstream' of
git://git.linux-mips.org/pub/scm/ralf/upstream-linus (2011-11-03
13:28:14 -0700)

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 ..BRANCH.NOT.VERIFIED..

Grant Likely (1):
      Merge branch 'for-grant' of
git://sources.calxeda.com/kernel/linux into devicetree/merge

Nicolas Ferre (1):
      dt: add empty of_alias_get_id() for non-dt builds

Olof Johansson (1):
      dt/platform: minor cleanup

Rob Herring (1):
      ahci: add DT binding for Calxeda AHCI controller

 .../devicetree/bindings/ata/calxeda-sata.txt       |   17 ++++++++++++
 drivers/ata/ahci_platform.c                        |    7 +++++
 drivers/of/platform.c                              |   28 +++++++++++--------
 include/linux/of.h                                 |    5 +++
 4 files changed, 45 insertions(+), 12 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ata/calxeda-sata.txt


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
