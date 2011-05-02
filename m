Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703Ab1EBUHm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 16:07:42 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:60588 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846Ab1EBUHl (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 2 May 2011 16:07:41 -0400
Date: Mon, 2 May 2011 16:07:30 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: yinghai@kernel.org, Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] Re: [PATCH] Two patches fixing regression introduced
 by 'x86-64, mm: Put early page table high'
Message-ID: <20110502200730.GA15557@dumpdata.com>
References: <1304356942-17656-1-git-send-email-konrad.wilk@oracle.com>
 <4DBEEA69.7010000@zytor.com>
 <20110502180802.GA7498@dumpdata.com>
 <4DBEF8EC.7080301@zytor.com>
 <20110502193436.GA14666@dumpdata.com>
 <4DBF0D0C.8000105@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DBF0D0C.8000105@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4DBF0F07.0060:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 02, 2011 at 12:59:08PM -0700, H. Peter Anvin wrote:
> On 05/02/2011 12:34 PM, Konrad Rzeszutek Wilk wrote:
> > On Mon, May 02, 2011 at 11:33:16AM -0700, H. Peter Anvin wrote:
> >> On 05/02/2011 11:08 AM, Konrad Rzeszutek Wilk wrote:
> >>>>
> >>>> My inclination would be to apply your workaround -- are there any
> >>>> adverse effects to doing that?
> >>>
> >>> There is a bootup slowdown (not noticeable). That is because we call the
> >>> 'memblock_find_range' function on every PTE table creation (only during
> >>> bootup of course). 
> >>>
> >>> Testing wise, on the machines on which the regression occurred, with these two
> >>> patches the regression disappears - so that is a good sign. I am testing
> >>> it on some more today to assure myself I am not missing anything.
> >>>
> >>
> >> OK, sounds like a plan then.  I like it because it doesn't affect the
> >> native kernel.
> > 
> > <laughs> I figured :-)
> > 
> > Moving forward I really want to get rid of this wart.
> > 
> > Not sure if it is possible, but I was thinking it would be nice to get
> > you, Yinghai, Jeremy, Stefano all in one place (phone or web-conference thing)
> > to sketch out some ideas and hammer something out.
> > 
> > What days would work best?
> 
> First things first... are you pushing the workaround (you can add my
> Acked-by:) or should I?

I will do it tomorrow and stick your Acked-by on both patches.
> 
> Second... I don't know what physical locations and/or time zones every
> one is in, which is probably the first thing.

EST for me, Jeremy is PST (California), Stefano is in UK, so that is UTC+0, and
no idea where Yinghai is.

But people are on vacation time right now so or until next week, plus
> Third, I will be travelling a lot over the next two weeks, plus we are

.. you are traveling.
> getting close to merge window time, so it might be hard to schedule
> before the merge window.  Are you looking at trying to push something
> for .40?  If so, you probably should have an implementation in mind
> already.  If not, I suggest we aim for after the merge window is over or
> at least quieted down.

.. and I don't have any implementation in mind yet. Was hoping we could
brainstorm something together.

OK, let me bug you guys when the merge window is over.

> 	
> 	-hpa
