Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708Ab2EAUpm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 16:45:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39791 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751877Ab2EAUpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 16:45:41 -0400
From: NeilBrown <neilb@suse.de>
To: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Wed, 02 May 2012 06:44:49 +1000
Subject: [PATCH 0/2] Make TWL4030_ALLOW_UNSUPPORTED more configurable.
Cc: linux-kernel@vger.kernel.org
Message-ID: <20120501204259.27026.40156.stgit@notabene.brown>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a revised version on an earlier patch based on feedback from
Mark.  And it is now two patches :-)

First patch collects some related #defines together because I wasted
way too much time being confused because they were separate.
The second converts TWL4030_ALLOW_UNSUPPORTED from a CONFIG option
to a feature flag.

Thanks,
NeilBrown


---

NeilBrown (2):
      twl-regulator: make TWL4030_ALLOW_UNSUPPORTED more configurable.
      twl-regulator: define all feature flags in one place.


 drivers/mfd/twl-core.c            |    7 -------
 drivers/regulator/twl-regulator.c |   12 +++++-------
 include/linux/i2c/twl.h           |   13 +++++++++++--
 3 files changed, 16 insertions(+), 16 deletions(-)

-- 
Signature

