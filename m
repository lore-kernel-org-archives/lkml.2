Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546Ab2EHToh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 15:44:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44853 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755426Ab2EHTog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 15:44:36 -0400
From: NeilBrown <neilb@suse.de>
To: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Date: Wed, 09 May 2012 05:43:59 +1000
Subject: [PATCH 0/2] MFD/regulator: make TWL4030_ALLOW_UNSUPPORTED more
 configurable.
Cc: linux-kernel@vger.kernel.org
Message-ID: <20120508193938.31629.64303.stgit@notabene.brown>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a resend, rebased on linux-next (next-20120508) which
simplifies the second patch slightly.

Thanks,
NeilBrown


---

NeilBrown (2):
      regulator: twl-regulator: make TWL4030_ALLOW_UNSUPPORTED more configurable.
      MFD: twl-regulator: define all feature flags in one place.


 drivers/mfd/twl-core.c            |    7 -------
 drivers/regulator/twl-regulator.c |   10 ++++------
 include/linux/i2c/twl.h           |   13 +++++++++++--
 3 files changed, 15 insertions(+), 15 deletions(-)

-- 
Signature

