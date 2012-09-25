Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525Ab2IYLUE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 07:20:04 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34152 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755280Ab2IYLTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 07:19:55 -0400
Date: Tue, 25 Sep 2012 12:19:37 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, alsa-devel@alsa-project.org,
        Kukjin Kim <kgene.kim@samsung.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        linux-next@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: [alsa-devel] [PATCH 0/2] dmaengine: Fix compillation issues in
 device_prep_dma_cyclic()
Message-ID: <20120925111937.GA32685@sirena.org.uk>
References: <20120924133923.130c4db72aa8105cb5647d7a@canb.auug.org.au>
 <1348473485-5081-1-git-send-email-peter.ujfalusi@ti.com>
 <s5hmx0fomwk.wl%tiwai@suse.de>
 <s5h8vbz8fa7.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h8vbz8fa7.wl%tiwai@suse.de>
X-Cookie: This is a good time to punt work.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 08:08:32PM +0200, Takashi Iwai wrote:
> At Mon, 24 Sep 2012 10:17:15 +0200,

> > Mark, could you tell me when it's ready?  Since I'll be off from
> > tomorrow, I'd like to resolve sooner.

> My time is up, so I merged Peter's two patches on the top of for-next
> branch of sound git tree now.  Mark, please pull them to your tree if
> needed.

Oh, well.  I was travelling for the entire time between Peter posting
the patches and you applying them :/
