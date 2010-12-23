Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209Ab0LWL4e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 06:56:34 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44407 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753048Ab0LWL4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 06:56:32 -0500
Date: Thu, 23 Dec 2010 11:56:44 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Piotr Hosowicz <piotr@hosowicz.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>, "'Takashi Iwai'" <tiwai@suse.de>,
        "'Stephen Rothwell'" <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Jassi Brar'" <jassi.brar@samsung.com>
Subject: Re: linux-next: manual merge of the sound tree with the s5p tree
Message-ID: <20101223115644.GA14889@opensource.wolfsonmicro.com>
References: <20101223115339.1ce18216.sfr@canb.auug.org.au>
 <003f01cba28c$872214f0$95663ed0$%kim@samsung.com>
 <s5hk4j0n43g.wl%tiwai@suse.de>
 <004001cba292$3827d2d0$a8777870$%kim@samsung.com>
 <20101223115024.GA28928@sirena.org.uk>
 <4D133872.5050804@example.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D133872.5050804@example.com>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 23, 2010 at 12:54:26PM +0100, Piotr Hosowicz wrote:
> On 23.12.2010 12:50, Mark Brown wrote:

> >topic/asoc is in Takashi's tree and is equivalent to my for-next branch,
> >it usually lags it by only a small amount.  Takashi's tree is at:

> >   git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6.git

> Each time I get source from Linus tree I get alsa source from
> Takashi and build the kernel. Should I get the source also from you
> to be up to date with sound source?

Only if you're doing embedded development (my tree is only for embedded
stuff) and then only if you really want the bleeding edge stuff - it's
usually at most a few days before any changes in the embedded branch get
sent to Takashi.  If you've never heard of the tree before you probably
don't need it.
