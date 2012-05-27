Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751348Ab2E0WUA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 18:20:00 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37384 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750768Ab2E0WT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 18:19:59 -0400
Date: Sun, 27 May 2012 23:19:56 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Vinod Koul <vinod.koul@linux.intel.com>
Cc: Tomoya MORINAGA <tomoya.rohm@gmail.com>, alsa-devel@alsa-project.org,
        lars@metafoo.de, Takashi Iwai <tiwai@suse.de>,
        linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: [alsa-devel] [PATCH v5] sound/soc/lapis: add platform driver
	for ML7213
Message-ID: <20120527221956.GB25019@opensource.wolfsonmicro.com>
References: <1332158459-14880-1-git-send-email-tomoya.rohm@gmail.com> <20120321160913.GF3226@opensource.wolfsonmicro.com> <CANKRQnjoGN=uvej8B1BxPHAx7NQtOORD9yJRPUc134DrVmPzNg@mail.gmail.com> <20120326154009.GA17506@sirena.org.uk> <CANKRQnhn=ALR0ucv5gnvwnxwxBQX4ajm9Jo5qC0fL-EFjDdoZg@mail.gmail.com> <20120523093857.GC4085@opensource.wolfsonmicro.com> <CANKRQnhNWC2F6zKgBMJY7HnipJbA5p-=6Lz4uGZqBKNQ688Z3w@mail.gmail.com> <20120524100742.GH5361@opensource.wolfsonmicro.com> <CANKRQnj_LdGQPYPV7d5NNZBx8oM5aAGHu4qZidiiS6C4eNtNJQ@mail.gmail.com> <1337941231.1580.19.camel@vkoul-udesk3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337941231.1580.19.camel@vkoul-udesk3>
X-Cookie: Bridge ahead.  Pay troll.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2012 at 03:50:31PM +0530, Vinod Koul wrote:
> On Fri, 2012-05-25 at 18:30 +0900, Tomoya MORINAGA wrote:
> > On Thu, May 24, 2012 at 7:07 PM, Mark Brown

> > I'm not so familiar with Linux's DMA idea.
> > So we don't know whether non-cyclic dmaengine has problem or not.

Nobody has written the code, this is the problem!  If the code is not
there, you should try to write it.  If there is some great problem
writing the code then you should t

> First you should not be writing your own dma driver, it *needs* to use
> dmaenegine. We already have bunch of driver supported, so there may be a

He's already done that, their current code is all open coded dmaengine
stuff.

> > As you said, common code for DMA code can be best solution.
> > However, currently, the code is nothing.
> > So, I want you to accept our driver as first step.
> > Because I think supporting new device is more important for linux than
> > dmaengine common.

The existing code is far from nothing, there is a fairly substantial
dmaengine library there already which should share a big chunk of code
with any cyclic support.  If you were saying "this is too hard for
$REASON" that'd be one thing but that's not what you're saying here.
It's possible that there is actually some substantial difficult but
my first instinct would be that it should be relatively straightforward.
