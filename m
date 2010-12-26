Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab0LZX7c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Dec 2010 18:59:32 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36788 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752748Ab0LZX7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Dec 2010 18:59:31 -0500
Date: Sun, 26 Dec 2010 23:59:29 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Takashi Iwai <tiwai@suse.de>, Liam Girdwood <lrg@slimlogic.co.uk>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the sound tree (Was:
	Re: linux-next: build failure after merge of the sound-asoc tree)
Message-ID: <20101226235928.GA18334@opensource.wolfsonmicro.com>
References: <20101223120243.1617cd40.sfr@canb.auug.org.au> <20101223021212.GA25886@opensource.wolfsonmicro.com> <20101227104951.1ecad371.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101227104951.1ecad371.sfr@canb.auug.org.au>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 27, 2010 at 10:49:51AM +1100, Stephen Rothwell wrote:
> On Thu, 23 Dec 2010 02:12:12 +0000 Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> > above which can't build on x86 as x86 lacks generic hardirqs.  I've
> > pushed up a change which ifdefs out all the tracepoints when things are
> > built modular, but it seems unfortunate that x86 isn't doing the right
> > thing here, whatever ARM is doing seems to DTRT.

> The first of those errors is now present in the sound tree, so I have
> used the version of the sound tree that would have been in next-20101223
> if I had released it.

Hrm?  I thought you merged the ASoC tree before the sound tree, in which
case the above is somehwat surprising.  If the ASoC tree merged OK then
Takashi it should be a simple case of pulling my for-2.6.38 branch to
resolve the issue.
