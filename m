Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861Ab1GHT2t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 15:28:49 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:34770 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752813Ab1GHT2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 15:28:48 -0400
Subject: [GIT PULL] Regulator fixes for 3.0
From: Liam Girdwood <lrg@ti.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 8 Jul 2011 20:28:12 +0100
Message-ID: <1310153292.3534.39.camel@CNA0741383>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Some regulator fixes to be pulled for 3.0.

Thanks

Liam 

---

The following changes since commit 902daf6580cffe04721250fb71b5527a98718b11:

  Merge branch 'gpio/merge' of git://git.secretlab.ca/git/linux-2.6 (2011-07-08 09:01:11 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lrg/voltage-2.6.git for-linus

Axel Lin (1):
      regulator: db8500-prcmu: small fixes

Donggeun Kim (1):
      regulator: max8997: Fix setting inappropriate value for ramp_delay variable

Jonghwan Choi (1):
      regulator: max8952 - fix wrong gpio valid check

MyungJoo Ham (1):
      regulator: max8997: remove dependency on platform_data pointer

Tushar Behera (1):
      regulator: MAX8997: Fix for divide by zero error

 drivers/regulator/db8500-prcmu.c |   14 ++-------
 drivers/regulator/max8952.c      |    2 +-
 drivers/regulator/max8997.c      |   55 ++++++++++++++++++++------------------
 3 files changed, 33 insertions(+), 38 deletions(-)


