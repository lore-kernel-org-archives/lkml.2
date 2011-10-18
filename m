Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932306Ab1JROPJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 10:15:09 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:51156 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755565Ab1JROPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 10:15:06 -0400
X-Sasl-enc: 2Z/Zq4PRfKGw0iAUGwuZ4YcWVGl/jQFnQ8MW5z1jmC+u 1318947305
Date: Tue, 18 Oct 2011 07:14:05 -0700
From: Greg KH <greg@kroah.com>
To: David Rientjes <rientjes@google.com>
Cc: Christoph Hellwig <hch@infradead.org>, Josh Boyer <jwboyer@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] Update email address for stable patch submission
Message-ID: <20111018141405.GC17101@kroah.com>
References: <20111018011638.GQ1165@zod.bos.redhat.com>
 <20111018065852.GA6056@infradead.org>
 <alpine.DEB.2.00.1110180105080.8959@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1110180105080.8959@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 18, 2011 at 01:07:38AM -0700, David Rientjes wrote:
> On Tue, 18 Oct 2011, Christoph Hellwig wrote:
> 
> > > The stable@kernel.org email address has been replaced with the
> > > stable@vger.kernel.org mailing list.  Change the stable kernel rules to
> > > reference the new list instead of the semi-defunct email alias.
> > 
> > Does this mean it already stopped working?  I recently sent pathces
> > there but neither got an ACK nor a bounce or similar.
> > 
> 
> It was bouncing (and noticably so) as of a week ago but I believe hpa has 
> since setup an alias to point to stable@vger.kernel.org.  Linus cc'd his 
> own commit to it yesterday, a84a79e4d369, so as long as you didn't get a 
> bounce email it should have gone through.
> 
>  [ I believe Greg also has gone through everything with a
>    "Cc: stable@kernel.org" in Linus' tree as well, either automatically 
>    or because of the bounces. ]

Automatically, scripts are nice :)
