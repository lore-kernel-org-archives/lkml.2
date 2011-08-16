Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167Ab1HPKDW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 06:03:22 -0400
Received: from 1wt.eu ([62.212.114.60]:38776 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752003Ab1HPKDS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 06:03:18 -0400
Date: Tue, 16 Aug 2011 12:02:31 +0200
From: Willy Tarreau <w@1wt.eu>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Greg KH <gregkh@suse.de>, lwn@lwn.net,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: Re: [stable] Linux 3.0.2
Message-ID: <20110816100231.GA28425@1wt.eu>
References: <20110816015447.GA28885@kroah.com> <20110816015501.GB28885@kroah.com> <alpine.LNX.2.00.1108161110350.23471@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1108161110350.23471@swampdragon.chaosbits.net>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 16, 2011 at 11:11:43AM +0200, Jesper Juhl wrote:
> 
> > diff --git a/Makefile b/Makefile
> > index f124b18..794fa28 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -1,6 +1,6 @@
> >  VERSION = 3
> >  PATCHLEVEL = 0
> > -SUBLEVEL = 1
> > +SUBLEVEL = 2
> >  EXTRAVERSION =
> 
> Isn't it time we remove that EXTRAVERSION from the stable kernels now that 
> they are using SUBLEVEL ?

It can be left empty here, it's still used a lot when doing specific builds
that need to embed a variant name (make bzImage modules EXTRAVERSION=xxx).

Regards,
Willy

