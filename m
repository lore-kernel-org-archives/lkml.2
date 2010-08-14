Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757690Ab0HNRdy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 13:33:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38516 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753347Ab0HNRdy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 13:33:54 -0400
Date: Sat, 14 Aug 2010 10:33:45 -0700
From: Greg KH <gregkh@suse.de>
To: sedat.dilek@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>, wylda@volny.cz
Subject: Re: Call traces w/ 2.6.35.2 (not w/ 2.6.35.1 plus 2.6.35.2-rc1)
Message-ID: <20100814173345.GA27025@suse.de>
References: <AANLkTi=YL_VKKDU8ok=OYotPhyQcGsVB2O-PU29+70YT@mail.gmail.com> <AANLkTikP3FHZ0f7umRRzXcT1ytfa9XfE41UHmQ98kO2h@mail.gmail.com> <20100814134343.GD17430@suse.de> <AANLkTi=qDBpN-6Ro833nHXY5P5OcvFbBrjYW9A4ewREP@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=qDBpN-6Ro833nHXY5P5OcvFbBrjYW9A4ewREP@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 14, 2010 at 05:28:39PM +0200, Sedat Dilek wrote:
> On Sat, Aug 14, 2010 at 3:43 PM, Greg KH <gregkh@suse.de> wrote:
> > On Sat, Aug 14, 2010 at 08:36:30AM +0200, Sedat Dilek wrote:
> >> Hope this helps to give an overview what has changed:
> [...]
> >
> > I still fail to understand what you are trying to show here at all.
> >
> > confused,
> >
> > greg k-h
> >
> 
> I was trying to show you that the patches in .35.2-rc1 and .35.2 are
> not the same.

Yes, I know that, I did the release :)

> Normally, the rcX patches become the final ones.
> 
> Unfortunately, I was too lazy to check the names of the patches and
> simply compared the files that have been modified (lines beginning
> with "diff --git a/file b/file").
> 
> In the meantime, Mr./Mrs.(?) "wylda" (sorry, don't know if first or
> last name) bisected the problem [1].
> 
> The confusing part for me is why "fresh" upstream patches entered a
> 2.6.35.y fix-series.

They were deemed necessary for inclusion.

> I can't say if only i386 is concerned, but as
> 
> mm: fix missing page table unmap for stack guard page failure case
> mm: keep a guard page below a grow-down stack segment
> 
> are also upstream patches, I think the both cause problems for
> .35-gitX also [2].

Yes, Linus just posted a potential fix.  Can you try that out?

thanks,

greg k-h
