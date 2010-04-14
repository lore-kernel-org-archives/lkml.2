Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756465Ab0DNQgo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 12:36:44 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:43625 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756441Ab0DNQgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 12:36:42 -0400
Date: Wed, 14 Apr 2010 18:36:37 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Pedro Ribeiro <pedrib@gmail.com>, linux-usb@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Greg KH <gregkh@suse.de>,
       alsa-devel@alsa-project.org
Subject: Re: USB transfer_buffer allocations on 64bit systems
Message-ID: <20100414163637.GV30807@buzzloop.caiaq.de>
References: <t2w74fd948d1004140347k3447bffapb73856eacddfde55@mail.gmail.com>
 <Pine.LNX.4.44L0.1004141003170.1716-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1004141003170.1716-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 14, 2010 at 10:08:47AM -0400, Alan Stern wrote:
> On Wed, 14 Apr 2010, Pedro Ribeiro wrote:
> > On 14 April 2010 11:09, Daniel Mack <daniel@caiaq.de> wrote:
> > > Thanks! So the only thing I can do for now is submit exactly this patch.
> > > At least, it helps you and it shouldn't break anything. The question
> > > remains whether this type of memory should be used for all
> > > transfer_buffers.
> > >
> > 
> > Is there any chance you could push this to -stable? I don't care
> > because I always use the latest kernel, but the next Debian stable and
> > Ubuntu LTS are going to use 2.6.32.
> 
> No!  Please don't do it: Don't submit the patch and _certainly_ don't
> submit it to -stable.  It doesn't fix anything; it only works around a
> bug, and at the moment we don't even know if the bug is in the kernel
> or in Pedro's hardware (and even though it affects two different
> systems of his, nobody else has reported a similar problem).  Papering
> over it will only remove the incentive to fix it properly.

No worries - I agree. But unfortunately, I'm out of ideas now, and my
initial thoughts about what might cause the trouble were abviously not
able to explain the issue. Does anyone see further steps of tracking
this issue down?

Thanks,
Daniel
