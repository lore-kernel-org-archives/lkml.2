Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168Ab1LTFqP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 00:46:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34043 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742Ab1LTFqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 00:46:08 -0500
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 20 Dec 2011 16:44:41 +1100
Subject: [PATCH 0/2] Two fixes for leds-tca6507 - Version 2
User-Agent: StGIT/0.14.3
Cc: rpurdie@rpsys.net, linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@xenotime.net>
Message-ID: <20111220054233.7043.3561.stgit@notabene.brown>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver didn't compile on arches which did not define GPIOLIB.
  Fix this by excluding gpio support on those archs.
  [Fix for the 'remove' function too]
  Reported by: Randy Dunlap <rdunlap@xenotime.net> and
     Stephen Rothwell <sfr@canb.auug.org.au>

off-by-one error in choose_times
  Reported by: Dan Carpenter <dan.carpenter@oracle.com>

Thanks,
NeilBrown

---

NeilBrown (2):
      leds-tca6507 - fix off by one error.
      leds-tca6507: allow driver to compile when GPIOLIB is not available.


 drivers/leds/leds-tca6507.c  |  100 +++++++++++++++++++++++++++++-------------
 include/linux/leds-tca6507.h |    3 +
 2 files changed, 71 insertions(+), 32 deletions(-)

-- 
Signature

