Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749Ab1ECWIc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 18:08:32 -0400
Received: from kroah.org ([198.145.64.141]:34299 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924Ab1ECWIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 18:08:31 -0400
Date: Tue, 3 May 2011 15:02:33 -0700
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/23] intel_sst: Save audio state across D3 on Medfield
Message-ID: <20110503220233.GB14080@kroah.com>
References: <20110503162919.24853.58699.stgit@bob.linux.org.uk>
 <20110503163128.24853.15446.stgit@bob.linux.org.uk>
 <20110503174254.GA6545@kroah.com>
 <20110503222903.4200a6bd@lxorguk.ukuu.org.uk>
 <20110503213925.GA7453@opensource.wolfsonmicro.com>
 <20110503225316.5371c96b@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110503225316.5371c96b@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 03, 2011 at 10:53:16PM +0100, Alan Cox wrote:
> > To recap the previous discussion: staging is just not in the slightest
> > bit viable for ASoC stuff, code that does anything non-trivial is going
> 
> Yes I know that - and its active development of a nice clean driver going
> on upstream so doesn't belong there anyway. The ASoC driver should
> probably have its own copy of the bits of the staging driver that it
> needs however.
> 
> I can fix this collision up easily enough and if doing it not via the
> rules is best fine by me. I think it might be wiser however if the ASoC
> driver took its own copy of the bits it actually needed.

That sounds like a good idea.

Mark, can you try to let me know if you are patching staging code?  If
you want to "own" a driver in the staging tree, that's fine, just let me
konw and I'll funnel patches to you for it (we do that for other staging
drivers).

It's just that for times like this, when I have no idea that someone
else modified it in linux-next, and then patches fail to apply, that it
gets messy.

thanks,

greg k-h
