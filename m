Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995Ab1KWRM5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 12:12:57 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51110 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754361Ab1KWRM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 12:12:56 -0500
Date: Wed, 23 Nov 2011 17:12:53 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Afzal Mohammed <afzal@ti.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Regulator fix for 3.2
Message-ID: <20111123171252.GH30049@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One driver-specific bugfix here for the TPS65910 regulators which fixes
voltage setting for the VDD1 and VDD2 regulators on the device.  The
commit itself was newly minted today but it's a cherry pick of a change
which has been in -next for some time now, the change looks independant
from code review and has been tested separately by Afzal.  

I'm sending the request as Liam is still not fully back on kernel.org as
he's in the middle of some house renovations.

The following changes since commit cfcfc9eca2bcbd26a8e206baeb005b055dbf8e37:

  Linux 3.2-rc2 (2011-11-15 15:02:59 -0200)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git for-linus

Afzal Mohammed (1):
      regulator: TPS65910: Fix VDD1/2 voltage selector count

 drivers/regulator/tps65910-regulator.c |   14 ++++++++------
 include/linux/mfd/tps65910.h           |    3 ++-
 2 files changed, 10 insertions(+), 7 deletions(-)
