Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221Ab1JUUFS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 16:05:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40579 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999Ab1JUUFQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 16:05:16 -0400
Date: Fri, 21 Oct 2011 22:02:57 +0200
From: Greg KH <gregkh@suse.de>
To: Stefan Priebe <s.priebe@profihost.ag>
Cc: LKML <linux-kernel@vger.kernel.org>, Stable Tree <stable@kernel.org>
Subject: Re: Kernel hard LOCKUP with v3.0.7
Message-ID: <20111021200257.GA31198@suse.de>
References: <4EA1536E.6090001@profihost.ag>
 <20111021130752.GC8219@suse.de>
 <AA4CF3E1-3D52-418E-BED9-F34BD22168C3@profihost.ag>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AA4CF3E1-3D52-418E-BED9-F34BD22168C3@profihost.ag>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 21, 2011 at 09:59:30PM +0200, Stefan Priebe wrote:
> > On Fri, Oct 21, 2011 at 01:11:42PM +0200, Stefan Priebe - Profihost AG wrote:
> >> Hello list,
> >> 
> >> today i've seen the following crash using v3.0.7 (renamed to 2.6.40.7).
> >> 
> >> http://pastebin.com/raw.php?i=sRq7T4Y0
> >> 
> >> I haven't seen this with 3.0.6 but i also changed some kernel config
> >> options (activated ipv6, changed from SLAB to SLUB).
> > 
> > Any way to reproduce it?
> > 
> > greg k-h
> No idea the systrm is just crashing every 2-6 hours. I've now also
> tried to use slab. No difference. So i will revert to 3.0.6 which is
> running fine.

Can you run 'git bisect' to try to find the problem patch?  Oh, there is
one bugfix that I know of, bcd5cff7216f9b2de0a148cc355eac199dc6f1cf in
Linus's tree, can you try that to see if it solves the problem for you?

thanks,

greg k-h
