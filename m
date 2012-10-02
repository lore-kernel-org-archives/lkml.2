Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873Ab2JBQJ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 12:09:26 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:59948 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754834Ab2JBQJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 12:09:25 -0400
X-Sasl-enc: fUto9zTiBrYAEqHuas6+nTjK0Q54DQogPpmeVc7c7cBJ 1349194164
Date: Tue, 2 Oct 2012 09:09:23 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: NeilBrown <neilb@suse.de>
Cc: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [ 094/127] md: make sure metadata is updated when spares are
 activated or removed.
Message-ID: <20121002160923.GA22726@kroah.com>
References: <20120928203045.835238916@linuxfoundation.org>
 <20120928203056.912250649@linuxfoundation.org>
 <1348872664.6858.7.camel@deadeye.wl.decadent.org.uk>
 <20120928235745.GA11630@kroah.com>
 <20121002125200.6bf40ac7@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121002125200.6bf40ac7@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 12:52:00PM +1000, NeilBrown wrote:
> On Fri, 28 Sep 2012 16:57:45 -0700 Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> 
> > On Sat, Sep 29, 2012 at 12:51:04AM +0200, Ben Hutchings wrote:
> > > On Fri, 2012-09-28 at 13:34 -0700, Greg Kroah-Hartman wrote:
> > > > 3.0-stable review patch.  If anyone has any objections, please let me know.
> > > > 
> > > > ------------------
> > > > 
> > > > From: NeilBrown <neilb@suse.de>
> > > > 
> > > > commit 6dafab6b1383e912cd252fa809570b484eb6e0dc upstream.
> > > [...]
> > > > This is suitable for -stable as out-of-data metadata could lead
> > > > to data corruption.
> > > > This is only relevant for 3.3 and later 9when 'replacement' as
> > > > introduced.
> > > [...]
> > > 
> > > Assuming Neil hasn't changed his mind about this, it should therefore
> > > not be applied to 3.0.
> > 
> > Neil, is this true?
> > 
> > greg k-h
> 
> Yes it is true - my bad.
> 
> I should have realised that when you pointed out that the backport wasn't
> clean.
> The patch won't hurt 3.0, but it isn't necessary at all, so best leave it out.

Thanks for letting us know, I've now dropped this.

greg k-h
