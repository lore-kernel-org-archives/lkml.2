Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab2ITHbM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 03:31:12 -0400
Received: from tee.schottelius.org ([77.109.138.222]:59211 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753139Ab2ITHbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 03:31:10 -0400
Date: Thu, 20 Sep 2012 09:32:45 +0200
From: Nico Schottelius <nico-kernel20120920@schottelius.org>
To: David Rientjes <rientjes@google.com>
Cc: Nico Schottelius <nico-kernel20120920@schottelius.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Out of memory on 3.5 kernels
Message-ID: <20120920073245.GA1327@schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-kernel20120920@schottelius.org>,
	David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org
References: <20120920060202.GB10758@schottelius.org>
 <alpine.DEB.2.00.1209192351440.30029@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1209192351440.30029@chino.kir.corp.google.com>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: brief (Linux 3.5.4-1-ARCH x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey David,

David Rientjes [Wed, Sep 19, 2012 at 11:54:54PM -0700]:
> On Thu, 20 Sep 2012, Nico Schottelius wrote:
> 
> > for some time the slab usage is quite high (~3.2 GiB) and whenever I try
> > to do a backup with ccollect (which is using rsync), a lot of processes
> > (like chromium) are being killed over night.
> > 
> 
> Yeah, over 81% of your memory is consumed by slab and that doesn't shrink 
> over the duration of the log you posted.  It would be interesting to see 
> if there was a leak somewhere: try looking at slabtop and determining if 
> you have a cache using an egregious amount of memory;

I already had to reboot, because no now process was starting / only
starting extremly slowly.

> if there aren't any 
> clear winners, then we'll still see what is hogging most of your memory 
> and see how it compares to 3.4.2.  You can also check if there is a leak 
> using kmemleak, but this requires a reboot (see 
> Documentation/kmemleak.txt).

I'll have a look at this one after the next reboot; I also have to
update to a recent kernel and enable CONFIG_DEBUG_KMEMLEAK, which is
missing in Archlinux' kernel.

Thanks for the pointers, it can only take a day until I have this
problem again - will then follow up this mail.

Cheers,

Nico

-- 
PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0
