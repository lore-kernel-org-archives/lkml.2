Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933Ab2HSHln (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 03:41:43 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:20179 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231Ab2HSHlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 03:41:42 -0400
Date: Sun, 19 Aug 2012 09:41:40 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        James.Bottomley@HansenPartnership.com, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 01/31] Disable const sections for PA-RISC
Message-ID: <20120819074140.GA12617@merkur.ravnborg.org>
References: <1345311022-26328-1-git-send-email-andi@firstfloor.org> <1345311022-26328-2-git-send-email-andi@firstfloor.org> <20120818211549.GA12298@merkur.ravnborg.org> <20120819020710.GO11413@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120819020710.GO11413@one.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 19, 2012 at 04:07:10AM +0200, Andi Kleen wrote:
> > > +config BROKEN_RODATA
> > > +	bool
> > > +	default y
> > 
> > Could you please change this so we have a commonly defined HAVE_BROKEN_RODATA
> > symbol. Then arch's that have broken RO data can select this symbol.
> > If we experience tomorrow that sparc have the same issue then with
> > this patch sparc has to create a local definition of this symbol.
> 
> Here's an updated patch with the config placed in init/Kconfig.

Looks good!

> I'm not going to repost the whole series.
> 
> -Andi
> 
> ---
> 
> Disable const sections for PA-RISC v2
> 
> The PA-RISC tool chain seems to have some problem with correct read/write
> attributes on sections. This causes problems when the const sections
> are fixed up for other architecture to only contain truly read-only
> data.
> 
> Disable const sections for PA-RISC
> 
> This can cause a bit of noise with modpost.
> 
> v2: Move config to init/Kconfig
> Cc: James.Bottomley@HansenPartnership.com
Acked-by: Sam Ravnborg <sam@ravnborg.org>

> Signed-off-by: Andi Kleen <ak@linux.intel.com>

	Sam
