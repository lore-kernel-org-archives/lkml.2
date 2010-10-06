Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758589Ab0JFDfd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 23:35:33 -0400
Received: from kroah.org ([198.145.64.141]:34865 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758563Ab0JFDf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 23:35:28 -0400
Date: Tue, 5 Oct 2010 20:36:05 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Charulatha V <charu@ti.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org
Subject: Re: linux-next: manual merge of the staging-next tree with the
	omap tree
Message-ID: <20101006033605.GB5719@kroah.com>
References: <20101006142110.e757f27c.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101006142110.e757f27c.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 06, 2010 at 02:21:10PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging-next tree got a conflict in
> arch/arm/plat-omap/devices.c between commit
> f2ce62312650211f6cf665cd6dc519c334c4071e ("OMAP: WDT: Split OMAP1 and
> OMAP2PLUS device registration") from the omap tree and commit
> 90173882ed15a8034d6d162da5f343a2c7d87587 ("omap: add dsp platform
> device") from the staging-next tree.
> 
> Just overlapping removal/additions (I think).  I fixed it up (see below)
> and can carry the changes as necessary.

Your fixup looks correct to me, thanks for carrying it.

greg k-h
