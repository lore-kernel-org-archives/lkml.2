Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455Ab1KUIIx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 03:08:53 -0500
Received: from ud10.udmedia.de ([194.117.254.50]:39349 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754414Ab1KUIIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 03:08:51 -0500
Date: Mon, 21 Nov 2011 09:08:49 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Christian Kujau <lists@nerdbynature.de>, linuxppc-dev@lists.ozlabs.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: 3.2.0-rc1 panic on PowerPC
Message-ID: <20111121080849.GC1625@x4.trippels.de>
References: <alpine.DEB.2.01.1111150035560.8000@trent.utfs.org>
 <alpine.DEB.2.01.1111201529070.8000@trent.utfs.org>
 <1321837101.13860.6.camel@pasglop>
 <alpine.DEB.2.01.1111201701000.8000@trent.utfs.org>
 <1321838742.13860.8.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321838742.13860.8.camel@pasglop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011.11.21 at 12:25 +1100, Benjamin Herrenschmidt wrote:
> On Sun, 2011-11-20 at 17:17 -0800, Christian Kujau wrote:
> > On Mon, 21 Nov 2011 at 11:58, Benjamin Herrenschmidt wrote:
> > > I've seen something similar with 3.2-rc2 at cfcfc9ec, unfortunately I
> > > couldn't capture the oops log at the time.
> > 
> > It just happened again today, after heavy CPU & IO load (rsyncing from/to 
> > external disks on dm-crypt). This time the oops was printed on the screen 
> > but nothing on netconsole:
> > 
> > http://nerdbynature.de/bits/3.2.0-rc1/oops/oops3m.JPG
> > 
> > It looks like the oops I reported earlier (oops2m.JPG) so I doubt it's a 
> > random corruption due to hardware issues...?
> 
> Yeah it's starting to look like a pattern. Your latest oops looks a lot
> like the one I had (though it was with tg3 on the g5), ie, vfs_read ->
> driver -> allocator -> crash.

I might be seeing a similar issue on x86_64. See:
http://thread.gmane.org/gmane.linux.kernel.mm/70254

-- 
Markus
