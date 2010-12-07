Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab0LGVdr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 16:33:47 -0500
Received: from kroah.org ([198.145.64.141]:52738 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753129Ab0LGVdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 16:33:23 -0500
Date: Tue, 7 Dec 2010 13:26:26 -0800
From: Greg KH <greg@kroah.com>
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
Cc: gregkh@suse.de, isimatu.yasuaki@jp.fujitsu.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] Patch "block: fix accounting bug on cross partition
 merges" has been added to the 2.6.36-stable tree
Message-ID: <20101207212626.GI14849@kroah.com>
References: <12904636664174@site>
 <201011250234.10424.s.L-H@gmx.de>
 <201012040302.01436.s.L-H@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201012040302.01436.s.L-H@gmx.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 04, 2010 at 03:01:57AM +0100, Stefan Lippers-Hollmann wrote:
> Hi
> 
> On Thursday 25 November 2010, Stefan Lippers-Hollmann wrote:
> > Hi
> > 
> > On Thursday 25 November 2010, gregkh@suse.de wrote: 
> > > This is a note to let you know that I've just added the patch titled
> > > 
> > >     block: fix accounting bug on cross partition merges
> > > 
> > > to the 2.6.36-stable tree which can be found at:
> > >     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
> Ping, this continues to be an issue with today's updated queue-2.6.36 
> and reverting this single patch still reliably avoids the problem with 
> unplugging USB storage devices. Is there anything else I could try to
> debug the regression introduced by this patch in queue-2.6.36 any 
> further?

I've now removed it from the .36 stable queue, thanks for letting me
know.

greg k-h
