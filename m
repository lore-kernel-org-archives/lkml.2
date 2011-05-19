Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321Ab1ESA3e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 20:29:34 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:45319 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753240Ab1ESA3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 20:29:32 -0400
X-Sasl-enc: Ol7n6x8bME9v4EHgY2xvFYXlKOpRaN9//yvTxPtRKpzq 1305764971
Date: Wed, 18 May 2011 17:25:43 -0700
From: Greg KH <greg@kroah.com>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, stable@kernel.org,
        Wolfgang Walter <wolfgang.walter@stwm.de>, Jiri Slaby <jslaby@suse.cz>,
        Linux-kernel <linux-kernel@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>
Subject: Re: [stable] apparent regression (crash) - 2.6.38.6
Message-ID: <20110519002543.GC8697@kroah.com>
References: <4DC9983B.4070006@msgid.tls.msk.ru>
 <4DCA2D14.3040500@suse.cz>
 <1305141557.2606.33.camel@mulgrave.site>
 <4DCAE408.4010205@msgid.tls.msk.ru>
 <4DCAF001.5060906@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DCAF001.5060906@msgid.tls.msk.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 12:22:25AM +0400, Michael Tokarev wrote:
> 11.05.2011 23:31, Michael Tokarev wrote:
> 
> >> http://marc.info/?l=linux-scsi&m=130348673628282
> 
> > I wonder why there's so many reports about this issue.
> 
> I mean, why there's so FEW reports about this issue.
> Should it happen rare?

I see lots of reports of this right now for openSUSE users with this
kernel release, so you aren't alone.

thanks,

greg k-h
