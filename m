Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267Ab0L0PoK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 10:44:10 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52968 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754198Ab0L0PoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 10:44:08 -0500
Date: Mon, 27 Dec 2010 15:44:21 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Takashi Iwai <tiwai@suse.de>, Liam Girdwood <lrg@slimlogic.co.uk>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the sound tree (Was:
 Re: linux-next: build failure after merge of the sound-asoc tree)
Message-ID: <20101227154421.GB13400@opensource.wolfsonmicro.com>
References: <20101223120243.1617cd40.sfr@canb.auug.org.au>
 <20101223021212.GA25886@opensource.wolfsonmicro.com>
 <20101227104951.1ecad371.sfr@canb.auug.org.au>
 <20101226235928.GA18334@opensource.wolfsonmicro.com>
 <20101228021657.44144877.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101228021657.44144877.sfr@canb.auug.org.au>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 28, 2010 at 02:16:57AM +1100, Stephen Rothwell wrote:
> On Sun, 26 Dec 2010 23:59:29 +0000 Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> > Hrm?  I thought you merged the ASoC tree before the sound tree, in which
> > case the above is somehwat surprising.  If the ASoC tree merged OK then
> > Takashi it should be a simple case of pulling my for-2.6.38 branch to
> > resolve the issue.

> I started merging the sound-asoc tree *after* the sound tree when the
> sound-asoc tree started to be merged into the sound tree.

That hasn't changed - ASoC has always been ahead of the sound tree and
merged into Linus' tree via the sound tree.  The frequency of merges has
increased.
