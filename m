Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550Ab1CBLTr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 06:19:47 -0500
Received: from mga01.intel.com ([192.55.52.88]:14553 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751989Ab1CBLTq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 06:19:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,252,1297065600"; 
   d="scan'208";a="892942481"
Date: Wed, 2 Mar 2011 12:19:42 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: vwadekar@nvidia.com, Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Manjunathappa@sortiz-mobl, Prakash <prakash.pm@ti.com>,
        Jochen Friedrich <jochen@scram.de>,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [GIT] [2.6.38] MFD fixes
Message-ID: <20110302111942.GG16181@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I have 5 MFD fixes for 2.6.38. Could you please pull them in ? Thanks in
advance.

The following changes since commit dd9c1549edef02290edced639f67b54a25abbe0e:

  Linux 2.6.38-rc7 (2011-03-01 13:55:12 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-2.6.git for-linus

Jochen Friedrich (1):
      mfd: Fix NULL pointer due to non-initialized ucb1x00-ts absinfo

Lennert Buytenhek (1):
      mfd: Fix ASIC3 build with GENERIC_HARDIRQS_NO_DEPRECATED

Manjunathappa, Prakash (1):
      mfd: Fix DaVinci voice codec device name

Mark Brown (1):
      mfd: Don't suspend WM8994 if the CODEC is not suspended

vwadekar@nvidia.com (1):
      mfd: Avoid tps6586x burst writes

 drivers/mfd/asic3.c              |    4 ++--
 drivers/mfd/davinci_voicecodec.c |    4 ++--
 drivers/mfd/tps6586x.c           |   10 +++++-----
 drivers/mfd/ucb1x00-ts.c         |   12 +++++++++---
 drivers/mfd/wm8994-core.c        |   18 ++++++++++++++++++
 include/linux/mfd/wm8994/core.h  |    1 +
 6 files changed, 37 insertions(+), 12 deletions(-)

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
