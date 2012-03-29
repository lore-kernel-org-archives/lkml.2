Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758842Ab2C2K5R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 06:57:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:35378 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751513Ab2C2K5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 06:57:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="126498644"
Subject: Re: [PATCH linux-next] dmaengine: add context parameter fixups
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Takashi Iwai <tiwai@suse.de>, Fabio Estevam <festevam@gmail.com>,
        Alexandre Bounine <alexandre.bounine@idt.com>,
        paul.gortmaker@windriver.com, dan.j.williams@intel.com,
        samuel@sortiz.org, lrg@ti.com, perex@perex.cz,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        netdev@vger.kernel.org, fabio.estevam@freescale.com,
        alsa-devel@alsa-project.org
In-Reply-To: <20120328155106.GY3232@opensource.wolfsonmicro.com>
References: <1332511242-30241-1-git-send-email-alexandre.bounine@idt.com>
	 <CAOMZO5B-Zutv-xwqLCAgNMO8A3Kyg4uWqS41koo-yoS4mGB1TQ@mail.gmail.com>
	 <1332740082.19804.15.camel@vkoul-udesk3>
	 <20120326094200.GA3098@opensource.wolfsonmicro.com>
	 <s5hwr64wx0p.wl%tiwai@suse.de>
	 <20120328155106.GY3232@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 Mar 2012 16:29:45 +0530
Message-ID: <1333018785.1820.48.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-28 at 16:51 +0100, Mark Brown wrote:
> On Wed, Mar 28, 2012 at 05:44:22PM +0200, Takashi Iwai wrote:
> > Mark Brown wrote:
> 
> > > No, not yet - it was only sent after the merge window.  Quite why nobody
> > > managed to notice it before then I don't know.  It'll go to him soon, or
> > > at least to Takashi, but don't know if it'll make -rc1 or not.
> 
> > How is the situation now?
> 
> > FYI, I'm going to send a pull request to Linus tomorrow or on Friday.
> > If anything needed to be merged in rc1, it must be there in time.
> 
> It's in my tree, I didn't see an enormous rush to get it in TBH.
I should be sending the pull request for slave-dma to Linus this
evening.
Can you please include the fix I did in your tree in your pull request.


-- 
~Vinod

