Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104Ab0KJRbB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 12:31:01 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59882 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751195Ab0KJRbA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 12:31:00 -0500
Date: Wed, 10 Nov 2010 09:28:42 -0800
From: Greg KH <gregkh@suse.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Claudio Scordino <claudio@evidence.eu.com>, linux-serial@vger.kernel.org,
        Grant Edwards <grant.b.edwards@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Documentation about RS485 serial communications
Message-ID: <20101110172842.GC12371@suse.de>
References: <20100408111310.524f7354@lxorguk.ukuu.org.uk> <4CBD8EE4.5040808@evidence.eu.com> <i9ka0s$4ua$1@dough.gmane.org> <201010191727.53314.alexander.stein@systec-electronic.com> <i9kk4o$svc$1@dough.gmane.org> <4CC418A9.6090602@evidence.eu.com> <4CDA630F.4060903@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CDA630F.4060903@atmel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 10:17:03AM +0100, Nicolas Ferre wrote:
> Le 24/10/2010 13:29, Claudio Scordino :
> 
> [..]
> 
> > Hi all,
> > 
> > 	sorry for the misuse of the term "transceiver", and thank you
> > for your corrections.
> > 
> > Hopefully, this new version of the document is slightly better.
> 
> Hi all,
> 
> This documentation is floating around for some time now. Claudio has
> enhanced it and it is maybe time to merge it in mainline...
> 
> So, can serial people include it in their tree (Greg?) or should it go
> through another path?

I can take it, if someone resends it with the accumulated acks that I
think it gathered over the review cycle.

thanks,

greg k-h
