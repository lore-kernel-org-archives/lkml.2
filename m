Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758838Ab2I1X5t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 19:57:49 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:54382 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758331Ab2I1X5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 19:57:47 -0400
X-Sasl-enc: 4TzSGULlGnTgtw+/tVUPXhIigB+zj1mgaG4FQ8CHD015 1348876666
Date: Fri, 28 Sep 2012 16:57:45 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, NeilBrown <neilb@suse.de>
Subject: Re: [ 094/127] md: make sure metadata is updated when spares are
 activated or removed.
Message-ID: <20120928235745.GA11630@kroah.com>
References: <20120928203045.835238916@linuxfoundation.org>
 <20120928203056.912250649@linuxfoundation.org>
 <1348872664.6858.7.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348872664.6858.7.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 29, 2012 at 12:51:04AM +0200, Ben Hutchings wrote:
> On Fri, 2012-09-28 at 13:34 -0700, Greg Kroah-Hartman wrote:
> > 3.0-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: NeilBrown <neilb@suse.de>
> > 
> > commit 6dafab6b1383e912cd252fa809570b484eb6e0dc upstream.
> [...]
> > This is suitable for -stable as out-of-data metadata could lead
> > to data corruption.
> > This is only relevant for 3.3 and later 9when 'replacement' as
> > introduced.
> [...]
> 
> Assuming Neil hasn't changed his mind about this, it should therefore
> not be applied to 3.0.

Neil, is this true?

greg k-h
