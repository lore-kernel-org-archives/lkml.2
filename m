Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031031Ab2I1UVg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:21:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52684 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030221Ab2I1UVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:21:34 -0400
Date: Fri, 28 Sep 2012 22:21:22 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Input and HID updates for 3.7
In-Reply-To: <20120928173539.GB6356@core.coreip.homeip.net>
Message-ID: <alpine.LNX.2.00.1209282218350.17437@pobox.suse.cz>
References: <20120919185605.GA778@polaris.bitmath.org> <alpine.LNX.2.00.1209192351120.22959@pobox.suse.cz> <20120928173539.GB6356@core.coreip.homeip.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Sep 2012, Dmitry Torokhov wrote:

> > > Please pull this tree to receive Input and HID updates for 3.7. The
> > > tree contains input core changes, Acked by Dmitry, which substantially
> > > reduces the irqsoff latency for all input devices. It also contains MT
> > > changes which allows further memory reduction, speedup and hardware
> > > support in the HID Multitouch driver. Lastly, you get the conversion
> > > of the bcm5974 driver to MT-B, which due to the mixed dependency of
> > > the tree fits better here than anywhere else.
> > > 
> > > Thanks,
> > > Henrik
> > > 
> > > The following changes since commit 4cbe5a555fa58a79b6ecbb6c531b8bab0650778d:
> > > 
> > >   Linux 3.6-rc4 (2012-09-01 10:39:58 -0700)
> > > 
> > > are available in the git repository at:
> > > 
> > >   git://github.com/rydberg/linux.git for-next
> > 
> > Pulled. Thanks Henrik, thanks Dmitry.
> 
> Hmm, it looks like the work on making evdev using dynamic device numbers
> will clash with Henrik's changes. I think I will also pull this into my
> tree and then git should be able to resolve it all properly in -next.

That should work. Alternatively you can pull 'from-henrik' branch from my 
tree in case Henrik has already ditched/rebased his tree.

And when merging to Linus shouldn't really matter, git should handle that 
as well nicely.

-- 
Jiri Kosina
SUSE Labs
