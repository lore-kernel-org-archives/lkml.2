Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934096Ab2JaCd7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 22:33:59 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:42429 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759824Ab2JaCd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 22:33:57 -0400
X-AuditID: 9c930179-b7c8bae000003559-e5-50908e10aa7d
Date: Wed, 31 Oct 2012 11:39:48 +0900
From: Minchan Kim <minchan@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Nitin Gupta <ngupta@vflare.org>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Jens Axboe <axboe@kernel.dk>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>, gaowanlong@cn.fujitsu.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 0/3] zram/zsmalloc promotion
Message-ID: <20121031023947.GA24883@bbox>
References: <1351501009-15111-1-git-send-email-minchan@kernel.org>
 <20121031010642.GN15767@bbox>
 <20121031014209.GB2672@kroah.com>
 <20121031020443.GP15767@bbox>
 <20121031021618.GA1142@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121031021618.GA1142@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2012 at 07:16:18PM -0700, Greg Kroah-Hartman wrote:
> On Wed, Oct 31, 2012 at 11:04:43AM +0900, Minchan Kim wrote:
> > Hi Greg,
> > 
> > On Tue, Oct 30, 2012 at 06:42:09PM -0700, Greg Kroah-Hartman wrote:
> > > On Wed, Oct 31, 2012 at 10:06:42AM +0900, Minchan Kim wrote:
> > > > Thanks all,
> > > > 
> > > > At last, everybody who contributes to zsmalloc want to put it under /lib.
> > > > 
> > > > Greg,
> > > > What should I do for promoting this dragging patchset?
> > > 
> > > You need to get the -mm developers to agree that this is something that
> > > is worth accepting.  I have yet to see any compeling argument why this
> > 
> > I'm one of mm developers. :)
> > Yes. I hope Andrew have a time to take a look.
> > 
> > > even needs to be in the kernel in the first place.
> > 
> > Confused. what do you mean "this"? "zsmalloc" or "zram" or "both"?
> > If you mean "zsmalloc", I guess there were some lengthy thread about
> > "why we need a new another allocator". Unfortunately, I didn't follow it
> > at that time. Nitin, Pekka, Could you point out that thread? or summarize
> > the result.
> > 
> > > 
> > > I'm not moving this anywhere until you get their acceptance.
> > 
> > I understand you.
> > 
> > It's one of problem in current mm mailing list.
> > As you know, many mm guys works for server, not embedded so they don't have
> > big interest about embedded feature so prioirty of the feature was always
> > low. CMA proved it and next turn is zram. Even new-comer in mm is few so
> > review bandwidth is always low, too. :(
> > 
> > How can I poke them?
> 
> You just did.  If they ignore this, wait a week, and resend.
> Persistance is key.
> 
> good luck,

Okay. I will wait.
Greg, what do you think about LTSI?
Is it proper feature to add it? For it, still do I need ACK from mm developers?

> 
> greg k-h
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Kind regards,
Minchan Kim
