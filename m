Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326Ab1ILUBb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 16:01:31 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:40222 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081Ab1ILUB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 16:01:28 -0400
Date: Mon, 12 Sep 2011 14:01:25 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Mark Salter <msalter@redhat.com>, linux-kernel@vger.kernel.org,
        Deepak Saxena <dsaxena@linaro.org>
Subject: Re: [PATCH 11/24] C6X: interrupt handling
Message-ID: <20110912200125.GE23345@ponder.secretlab.ca>
References: <1314826019-22330-1-git-send-email-msalter@redhat.com>
 <1314826019-22330-12-git-send-email-msalter@redhat.com>
 <alpine.LFD.2.02.1109091619350.2723@ionos>
 <1315837623.11280.14.camel@deneb.redhat.com>
 <alpine.LFD.2.02.1109121629450.2723@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1109121629450.2723@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 12, 2011 at 04:30:36PM +0200, Thomas Gleixner wrote:
> On Mon, 12 Sep 2011, Mark Salter wrote:
> 
> > On Fri, 2011-09-09 at 16:33 +0200, Thomas Gleixner wrote:
> > > On Wed, 31 Aug 2011, Mark Salter wrote:
> > > 
> > > > + *
> > > > + *  Large parts taken directly from powerpc.
> > > 
> > > Is it really necessary to copy that stuff instead of generalizing it ?
> > > I guess that's mostly about the reverse map & Co.
> > 
> > I have a patch that takes the code out of powerpc and puts in kernel/irq
> > where both powerpc and c6x can use it. That leaves us with two files in
> > kernel/irq trying to manage hw <--> virt mappings. So, some merging of
> > irqdomain.c and the former powerpc code is needed. I'm not sure how that
> > should go. At the moment, irqdomain doesn't support dynamic allocation
> > of irq_descs, so its not currently suitable for powerpc or c6x.
> 
> Grant was working on that as well. You should talk to him.

Yes, I've been working on it, but it isn't complete.  Summer hit and
all my hacking time went to travel and being a father to my
home-from-school children.  :-)

I believe Deepak is getting an engineer assigned from Linaro to help me finish
the work of migrating PowerPC to use irqdomain.c.  We talked about it
last week at Linux Plumbers conference.

g.
