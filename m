Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257Ab1LLO3k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 09:29:40 -0500
Received: from mga11.intel.com ([192.55.52.93]:3196 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752792Ab1LLO3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 09:29:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="95214498"
Date: Mon, 12 Dec 2011 15:34:42 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 0/8] WM8994 MFD updates for 3.3
Message-ID: <20111212143442.GG13952@sortiz-mobl>
References: <20111128224017.GA13163@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111128224017.GA13163@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Mon, Nov 28, 2011 at 10:40:18PM +0000, Mark Brown wrote:
> The following patch series (and pull request) contains a bunch of
> updates I've previously posted for wm8994 but which haven't been merged
> plus a big update adding register cache support for the wm8994 driver
> which hasn't previously been posted.  As there's a matching update for
> the ASoC driver for WM8994 removing the copy of the register cache there
> it'd be great if it were possible to merge this via the ASoC tree.
> 
> I've also got one more patch which depends on this lot converting the
> IRQ controller over to use the generic regmap IRQ controller which I'll
> post as well - that also depends on this series as the regmap interrupt
> controller relies on the register cache - so I'd also like to either
> pull the same branch into the regmap tree or merge both this and the
> regmap IRQ stuff via ASoC.
> 
> This seems like the easiest route from the point of view of bisection
> and cross tree issues - does that all sound OK to you?
Yes, that sounds good. Please add my:

Acked-by: Samuel Ortiz <sameo@linux.intel.com>

to this patchset.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
