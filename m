Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965299Ab2JaCPX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 22:15:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59356 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069Ab2JaCPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 22:15:21 -0400
Date: Tue, 30 Oct 2012 19:16:18 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Nitin Gupta <ngupta@vflare.org>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Jens Axboe <axboe@kernel.dk>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>, gaowanlong@cn.fujitsu.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 0/3] zram/zsmalloc promotion
Message-ID: <20121031021618.GA1142@kroah.com>
References: <1351501009-15111-1-git-send-email-minchan@kernel.org>
 <20121031010642.GN15767@bbox>
 <20121031014209.GB2672@kroah.com>
 <20121031020443.GP15767@bbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121031020443.GP15767@bbox>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2012 at 11:04:43AM +0900, Minchan Kim wrote:
> Hi Greg,
> 
> On Tue, Oct 30, 2012 at 06:42:09PM -0700, Greg Kroah-Hartman wrote:
> > On Wed, Oct 31, 2012 at 10:06:42AM +0900, Minchan Kim wrote:
> > > Thanks all,
> > > 
> > > At last, everybody who contributes to zsmalloc want to put it under /lib.
> > > 
> > > Greg,
> > > What should I do for promoting this dragging patchset?
> > 
> > You need to get the -mm developers to agree that this is something that
> > is worth accepting.  I have yet to see any compeling argument why this
> 
> I'm one of mm developers. :)
> Yes. I hope Andrew have a time to take a look.
> 
> > even needs to be in the kernel in the first place.
> 
> Confused. what do you mean "this"? "zsmalloc" or "zram" or "both"?
> If you mean "zsmalloc", I guess there were some lengthy thread about
> "why we need a new another allocator". Unfortunately, I didn't follow it
> at that time. Nitin, Pekka, Could you point out that thread? or summarize
> the result.
> 
> > 
> > I'm not moving this anywhere until you get their acceptance.
> 
> I understand you.
> 
> It's one of problem in current mm mailing list.
> As you know, many mm guys works for server, not embedded so they don't have
> big interest about embedded feature so prioirty of the feature was always
> low. CMA proved it and next turn is zram. Even new-comer in mm is few so
> review bandwidth is always low, too. :(
> 
> How can I poke them?

You just did.  If they ignore this, wait a week, and resend.
Persistance is key.

good luck,

greg k-h
