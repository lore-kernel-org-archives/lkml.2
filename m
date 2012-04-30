Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755605Ab2D3FGM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 01:06:12 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:54378 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755417Ab2D3FGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 01:06:06 -0400
Date: Sun, 29 Apr 2012 18:06:56 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: Eric =?iso-8859-1?Q?B=E9nard?= <eric@eukrea.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Wolfram Sang <w.sang@pengutronix.de>,
        Chris Ball <cjb@laptop.org>
Subject: Re: [ 14/62] mmc: unbreak sdhci-esdhc-imx on i.MX25
Message-ID: <20120430010656.GE25022@kroah.com>
References: <20120424223305.GA7748@kroah.com>
 <20120424223243.200037983@linuxfoundation.org>
 <20120427223118.GE2821@burratino>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120427223118.GE2821@burratino>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 05:31:18PM -0500, Jonathan Nieder wrote:
> Hi,
> 
> Greg KH wrote:
> 
> > 3.3-stable review patch.
> [...]
> > commit b89152824f993a9572b47eb31f4579feadeac34c upstream.
> >
> > This was broken by me in 37865fe91582582a6f6c00652f6a2b1ff71f8a78
> > ("mmc: sdhci-esdhc-imx: fix timeout on i.MX's sdhci") where more
> > extensive tests would have shown that read or write of data to the
> > card were failing (even if the partition table was correctly read).
> 
> 37865fe91582 is v2.6.37-rc4~24^2~7 so it sounds like this patch
> should also be applied to 3.0.y.
> 
> Here's a straightforward backport to account for the lack of
> v3.1-rc1~321^2~77 ("mmc: sdhci: make sdhci-pltfm device drivers self
> registered") and v3.1-rc1~125^2^2~5 ("mmc: sdhci-esdhc-imx: get rid of
> the uses of cpu_is_mx").  Sensible?

Looks good to me, thanks for doing this.
