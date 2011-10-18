Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab1JRTT5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 15:19:57 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:57514 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752821Ab1JRTT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 15:19:56 -0400
X-Sasl-enc: glDNdTWSc1CG1262k2EsQd3l8jxZxBD8sexp+4E08GpL 1318965595
Date: Tue, 18 Oct 2011 12:19:46 -0700
From: Greg KH <greg@kroah.com>
To: David Miller <davem@davemloft.net>
Cc: rientjes@google.com, hch@infradead.org, jwboyer@redhat.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] Update email address for stable patch submission
Message-ID: <20111018191946.GA22104@kroah.com>
References: <20111018011638.GQ1165@zod.bos.redhat.com>
 <20111018065852.GA6056@infradead.org>
 <alpine.DEB.2.00.1110180105080.8959@chino.kir.corp.google.com>
 <20111018.151421.864660896119319431.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111018.151421.864660896119319431.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 18, 2011 at 03:14:21PM -0400, David Miller wrote:
> From: David Rientjes <rientjes@google.com>
> Date: Tue, 18 Oct 2011 01:07:38 -0700 (PDT)
> 
> > On Tue, 18 Oct 2011, Christoph Hellwig wrote:
> > 
> >> > The stable@kernel.org email address has been replaced with the
> >> > stable@vger.kernel.org mailing list.  Change the stable kernel rules to
> >> > reference the new list instead of the semi-defunct email alias.
> >> 
> >> Does this mean it already stopped working?  I recently sent pathces
> >> there but neither got an ACK nor a bounce or similar.
> >> 
> > 
> > It was bouncing (and noticably so) as of a week ago but I believe hpa has 
> > since setup an alias to point to stable@vger.kernel.org.  Linus cc'd his 
> > own commit to it yesterday, a84a79e4d369, so as long as you didn't get a 
> > bounce email it should have gone through.
> 
> Not true.  VGER eats them silently because the forward from
> stable@kernel.org contains headers that are commonly found in
> looped-back postings which we regexp block at vger.  If vger responded
> in some way it would just exacerbate any real list loop.
> 
> Warty didn't thing he could fix it easily, so we decided it was most easy
> to just go straight to solely using stable@vger.kernel.org and just shut
> down stable@kernel.org

That's fine with me, and if stable@kernel.org is removed, it's best to
see the bounce-back happen, instead of them disappearing quietly.

greg k-h
