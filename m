Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758395Ab2IJXla (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 19:41:30 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:60874 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756499Ab2IJXl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 19:41:29 -0400
X-Sasl-enc: p6eDuJ5GuzS6GoA5ommKBi9gKLS0jlMn3bp5d/QWX3CX 1347320488
Date: Mon, 10 Sep 2012 16:38:49 -0700
From: Greg KH <greg@kroah.com>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Raphael Assenat <raph@8d.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] 1-Wire: Add support for the maxim ds1825 temperature
 sensor
Message-ID: <20120910233849.GA25405@kroah.com>
References: <20120816165639.GB22993@renkinjitsu.usine.8d.com>
 <20120818094818.GA11844@ioremap.net>
 <20120905210758.GD27262@kroah.com>
 <20120906182524.GA5237@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120906182524.GA5237@ioremap.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 10:25:24PM +0400, Evgeniy Polyakov wrote:
> Hi
> 
> On Wed, Sep 05, 2012 at 02:07:58PM -0700, Greg KH (greg@kroah.com) wrote:
> > > Greg, please pull it into your tree
> > > Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
> > 
> > I can't seem to find the original patch here, can someone please resend
> > it to me, with Evgeniy's ack added to it so I can apply it?
> 
> Here is patchwork link
> Do you need it with my ack?
> 
> https://patchwork.kernel.org/patch/1272361/

That link doesn't have a signed-off-by: from the original author.

Raphael, can you resend this to me with your signed-off-by: and
Evgeniy's acked-by added?

thanks,

greg k-h
