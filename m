Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975Ab1C3PFi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 11:05:38 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:55246 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234Ab1C3PFh (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 30 Mar 2011 11:05:37 -0400
Date: Wed, 30 Mar 2011 11:05:11 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Christoph Hellwig <hch@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Merge window closed - 2.6.39-rc1 out
Message-ID: <20110330150511.GA17010@dumpdata.com>
References: <AANLkTikwbY5mm10ZWg7B6XeSBkZXFqKcYVZfJCi2QGx_@mail.gmail.com>
 <20110330120151.GA23358@infradead.org>
 <20110330144359.GA16430@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110330144359.GA16430@dumpdata.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4D9346A3.00C3,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 10:43:59AM -0400, Konrad Rzeszutek Wilk wrote:
> On Wed, Mar 30, 2011 at 08:01:51AM -0400, Christoph Hellwig wrote:
> > On Tue, Mar 29, 2011 at 02:07:35PM -0700, Linus Torvalds wrote:
> > > So 2.6.39-rc1 is out there, and the merge window is closed. I still
> > > have to look over the cleancache pull request (which I got in plenty
> > > of time, but decided that I want to review after the merge window
> > > craziness is over), but other than that, we're done.
> > 
> > FYI, strong no for me for this one.  None of the comments why it's
> > utterly wrong have been addresses, and it hasn't even been posted
> 
> <scratches his head>
> The one I see is from V3, which was: "but no actual users.". There is code
> in zcache (drivers/staging/zcache), and naturally the Xen one that utilize
> this API (part of the cleancache API). I am probably missing other ones?

Ah, I did: https://lkml.org/lkml/2010/8/20/266 has the full list which
I think had been addressed.
