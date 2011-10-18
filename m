Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539Ab1JROtQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 10:49:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37090 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751118Ab1JROtP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 10:49:15 -0400
Date: Tue, 18 Oct 2011 10:49:02 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] Update email address for stable patch submission
Message-ID: <20111018144902.GS1165@zod.bos.redhat.com>
References: <20111018011638.GQ1165@zod.bos.redhat.com>
 <20111018065852.GA6056@infradead.org>
 <20111018141350.GB17101@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111018141350.GB17101@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 18, 2011 at 07:13:50AM -0700, Greg KH wrote:
> On Tue, Oct 18, 2011 at 02:58:52AM -0400, Christoph Hellwig wrote:
> > On Mon, Oct 17, 2011 at 09:16:39PM -0400, Josh Boyer wrote:
> > > The stable@kernel.org email address has been replaced with the
> > > stable@vger.kernel.org mailing list.  Change the stable kernel rules to
> > > reference the new list instead of the semi-defunct email alias.
> > 
> > Does this mean it already stopped working?  I recently sent pathces
> > there but neither got an ACK nor a bounce or similar.
> 
> It should have bounced.

It doesn't bounce anymore.  The alias exists again, and it forwards to
the vger list.  However, there are some configuration issues where some
kind of email loop (I'm very fuzzy on the details) can/does occur
between the two, and as far as I know anything getting sent to
stable@kernel.org is getting dropped on the floor.

> But, if you put a "Cc: stable@kernel.org" in the patch, I'm still
> picking that up properly when it goes to Linus's tree.
> 
> If I haven't responded to any patches you have sent to stable@ already,
> please resend them to stable@vger.kernel.org and cc: me to ensure it
> gets here.

As Christoph said, that doesn't help patches that need to be
retro-actively submitted.  I sent a couple last night before I
remembered the problems, hence this patch.

josh
