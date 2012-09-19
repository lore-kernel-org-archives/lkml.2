Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120Ab2ISAZQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 20:25:16 -0400
Received: from mga11.intel.com ([192.55.52.93]:15661 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756057Ab2ISAZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 20:25:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,446,1344236400"; 
   d="scan'208";a="223814682"
Date: Wed, 19 Sep 2012 02:24:39 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Dmitry Torokhov <dtor@mail.ru>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Tero Kristo <t-kristo@ti.com>,
        alsa-devel@alsa-project.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, Benoit Cousson <b-cousson@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 00/14] MFD/ASoC/Input: twl4030-audio submodule DT
 support
Message-ID: <20120919002439.GB3647@sortiz-mobl>
References: <1347273992-9107-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347273992-9107-1-git-send-email-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Mon, Sep 10, 2012 at 01:46:18PM +0300, Peter Ujfalusi wrote:
> Hello,
> 
> Generated on top of:
> git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git topic/omap
I applied the first 8 patches, but I'd like to get Mark's ACK for the rest of
the serie.
Unless you're expecting Mark to take the whole thing, in which case you can
add my:

Acked-by: Samuel Ortiz <sameo@linux.intel.com>

to the MFD patches.
Please let me know how you'd like to proceed.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
