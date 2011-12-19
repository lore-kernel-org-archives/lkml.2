Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077Ab1LSAXM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 19:23:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42205 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010Ab1LSAXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 19:23:10 -0500
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 19 Dec 2011 11:20:22 +1100
Subject: [PATCH 0/2] Two fixes for leds-tca6507
Cc: rpurdie@rpsys.net, linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Dan Carpenter <dan.carpenter@oracle.com>
Message-ID: <20111219001806.23170.14518.stgit@notabene.brown>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver didn't compile on arches which did not define GPIOLIB.
  This this by excluding gpio support on those archs.
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


 drivers/leds/leds-tca6507.c  |   83 +++++++++++++++++++++++++++++-------------
 include/linux/leds-tca6507.h |    3 +-
 2 files changed, 59 insertions(+), 27 deletions(-)

-- 
Signature

