Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869Ab0DLQ3u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 12:29:50 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38124 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757Ab0DLQ3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 12:29:49 -0400
Date: Mon, 12 Apr 2010 18:29:47 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Andi Kleen <andi@firstfloor.org>, Daniel Mack <daniel@caiaq.de>,
       Pedro Ribeiro <pedrib@gmail.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Greg KH <gregkh@suse.de>,
       alsa-devel@alsa-project.org, linux-usb@vger.kernel.org
Subject: Re: USB transfer_buffer allocations on 64bit systems
Message-ID: <20100412162947.GQ18855@one.firstfloor.org>
References: <20100412154323.GP18855@one.firstfloor.org> <Pine.LNX.4.44L0.1004121214460.1702-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1004121214460.1702-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 12, 2010 at 12:17:22PM -0400, Alan Stern wrote:
> On Mon, 12 Apr 2010, Andi Kleen wrote:
> 
> > > Well, the sound driver itself doesn't care for any of those things, just
> > > like any other USB driver doesn't. The USB core itself of the host
> > > controller driver should do, and as far as I can see, it does that, yes.
> > 
> > Hmm, still things must go wrong somewhere. Perhaps need some instrumentation
> > to see if all the transfer buffers really hit the PCI mapping functions.
> 
> Such a test has already been carried out earlier in this thread:
> 
> 	http://marc.info/?l=linux-usb&m=127074587029353&w=2
> 	http://marc.info/?l=linux-usb&m=127076841801051&w=2
> 	http://marc.info/?l=linux-usb&m=127082890510415&w=2

Hmm, thanks. But things must still go wrong somewhere, otherwise
the GFP_DMA32 wouldn't be needed?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
