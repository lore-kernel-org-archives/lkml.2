Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889Ab1K1HlR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 02:41:17 -0500
Received: from mga01.intel.com ([192.55.52.88]:19748 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750961Ab1K1HlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 02:41:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,582,1315206000"; 
   d="scan'208";a="95944916"
Message-Id: <20111128073337.815008177@intel.com>
User-Agent: quilt/0.48-1
Date: Mon, 28 Nov 2011 15:33:37 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Keith Packard <keithp@keithp.com>
cc: Takashi Iwai <tiwai@suse.de>
Cc: Sander Jansen <s.jansen@gmail.com>,
        Christopher White <c.white@pulseforce.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "Pierre-louis Bossart " <pierre-louis.bossart@intel.com>,
        "Zhenyu Wang" <zhenyu.z.wang@intel.com>,
        Jeremy Bush <contractfrombelow@gmail.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/4] Intel HDMI ELD fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keith,

The 4 patches are well tested and integrates the review comments.

The only missing part is hot plug notification for DP -- most DP monitors in
the market don't support DP audio well. So I cannot test this for now.

Thanks,
Fengguang

