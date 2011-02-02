Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956Ab1BBToK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 14:44:10 -0500
Received: from kroah.org ([198.145.64.141]:49646 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297Ab1BBToJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 14:44:09 -0500
Date: Wed, 2 Feb 2011 11:43:59 -0800
From: Greg KH <greg@kroah.com>
To: David Brown <davidb@codeaurora.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <rmk@arm.linux.org.uk>,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: Re: linux-next: manual merge of the msm tree with the arm tree
Message-ID: <20110202194359.GC27065@kroah.com>
References: <20110131131401.5d6c7646.sfr@canb.auug.org.au>
 <8ya4o8m70jp.fsf@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8ya4o8m70jp.fsf@huya.qualcomm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 02, 2011 at 10:29:14AM -0800, David Brown wrote:
> On Sun, Jan 30 2011, Stephen Rothwell wrote:
> 
> > Hi David,
> >
> > Today's linux-next merge of the msm tree got conflicts in
> > arch/arm/mach-msm/board-msm7x27.c, arch/arm/mach-msm/board-msm7x30.c,
> > arch/arm/mach-msm/board-qsd8x50.c and arch/arm/mach-msm/board-sapphire.c
> > between commit eda53d6d032effb653410b79e1b49e652a881744 ("ARM: P2V: avoid
> > initializers and assembly using PHYS_OFFSET") from the arm tree and
> > commit 07a3cc4814f790354d4c7be2c9dc6143a714a07a ("msm: Clean up useless
> > ifdefs") from the msm tree.
> >
> > I fixed it up (see below) and can carry the fix as necessary.
> 
> What is the best way to resolve this?  I can't really merge against
> Russell's tree, since he may need to rebase his tree before the merge
> window?

Public trees should never be rebased, so that shouldn't happen.

thanks,

greg k-h
