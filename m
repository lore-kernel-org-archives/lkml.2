Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427Ab2IMC4A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 22:56:00 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:62801 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933Ab2IMCz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 22:55:58 -0400
Date: Wed, 12 Sep 2012 19:55:52 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jason Baron <jbaron@redhat.com>
Cc: Joe Perches <joe@perches.com>, Jim Cromie <jim.cromie@gmail.com>,
        Kay Sievers <kay@vrfy.org>, Andrew Morton <akpm@linux-foundation.org>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] dev_<level> and dynamic_debug cleanups
Message-ID: <20120913025552.GA8824@kroah.com>
References: <cover.1345978012.git.joe@perches.com>
 <CAJfuBxyQc-XeNHxw0_XDs0JuCrNArNzcgsmrLya4ncDvSojZxQ@mail.gmail.com>
 <CAJfuBxyToA9-=c3H88GGba3GFX64kdbP4OCEC0f4trnBnjpU-w@mail.gmail.com>
 <20120906161359.GC23641@kroah.com>
 <20120906175313.GC9786@redhat.com>
 <1347498810.2749.0.camel@joe2Laptop>
 <20120913023948.GC3214@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120913023948.GC3214@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 10:39:48PM -0400, Jason Baron wrote:
> On Wed, Sep 12, 2012 at 06:13:30PM -0700, Joe Perches wrote:
> > On Thu, 2012-09-06 at 13:53 -0400, Jason Baron wrote:
> > > On Thu, Sep 06, 2012 at 09:13:59AM -0700, Greg Kroah-Hartman wrote:
> > > > Jason, any ACK on these, or any of the other random dynamic debug
> > > > patches floating around?  What am I supposed to be applying here?
> > []
> > > I just posted some follow up comments to Joe, so let's see where that
> > > discussion goes.
> > 
> > Jason, I think you need to ack these original 5 patches.
> > 
> 
> Hi,
> 
> Yes, they are certainly an improvement. Please add to the series:
> 
> Acked-by: Jason Baron <jbaron@redhat.com>

Um, can someone please resend these with the ack so I can pick them up?
They are long gone from my mboxes...

greg k-h
