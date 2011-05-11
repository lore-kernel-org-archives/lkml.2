Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932309Ab1EKQPv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:15:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:51550 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932169Ab1EKQPs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:15:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,353,1301900400"; 
   d="scan'208";a="887382"
Date: Wed, 11 May 2011 15:51:23 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Lesly A M <leslyam@ti.com>, Axel Lin <axel.lin@gmail.com>,
        Juergen Kilb <J.Kilb@phytec.de>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [GIT] [2.6.39] MFD fixes
Message-ID: <20110511135123.GB23897@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

As we're approaching 2.6.39, those are my last fixes for MFD. We have a build
failure, an omap-usb GPIO mismatch, and a twl4030 typo triggering a sleep
script configuration when it shouldn't do so.

Thanks a lot for pulling those in:

The following changes since commit 9f381a61f58bb6487c93ce2233bb9992f8ea9211:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6 (2011-05-10 17:39:01 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-2.6.git for-linus

Axel Lin (1):
      mfd: Fix asic3 build error

Juergen Kilb (1):
      mfd: Fixed gpio polarity of omap-usb gpio USB-phy reset

Lesly A M (1):
      mfd: Fix for the TWL4030 PM sleep/wakeup sequence

 drivers/mfd/asic3.c         |    2 +-
 drivers/mfd/omap-usb-host.c |    8 ++++----
 drivers/mfd/twl4030-power.c |    3 ++-
 3 files changed, 7 insertions(+), 6 deletions(-)

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
