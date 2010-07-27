Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469Ab0G0SOM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 14:14:12 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:24609 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206Ab0G0SOK (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 27 Jul 2010 14:14:10 -0400
Date: Tue, 27 Jul 2010 14:13:49 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vmap: add flag to allow lazy unmap to be disabled at
 runtime
Message-ID: <20100727181349.GA15674@phenom.dumpdata.com>
References: <4C4DEF13.1030403@goop.org>
 <20100727082439.GB6332@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100727082439.GB6332@amd>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4C4F21EA.017A:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 27, 2010 at 06:24:39PM +1000, Nick Piggin wrote:
> On Mon, Jul 26, 2010 at 01:24:51PM -0700, Jeremy Fitzhardinge wrote:
> > 
> > 
> > [ Nick, I forget if I sent this to you before.  Could you Ack it if it looks OK? Thanks, J ]
> > 
> > Add a flag to force lazy_max_pages() to zero to prevent any outstanding
> > mapped pages.  We'll need this for Xen.
> 
> You have sent this to me before, probably several times, and I always
> forget about it right as you send it again.
> 
> It's no problem merging something like this for Xen, although as you
> know I would love to see an approach where Xen would benefit from
> delayed flushing as well :)

Hey Nick,

So I've posted the patch with your Ack, in this thread
http://lkml.org/lkml/2010/7/27/246. I hope that is OK?

I think that using the delayed flushing is appropiate long-term.
I don't know that much about it but I will put it on the list of todo.
Fortunatly that list is actually shrinking (amazing!).
