Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466Ab1GBVJW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 17:09:22 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:40277 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752030Ab1GBVJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 17:09:21 -0400
X-Sasl-enc: A/9zCgO2RMbR7g9yfaIp5ZH2mTPYkN/a2AhkWgiowDdG 1309640958
Date: Sat, 2 Jul 2011 14:07:29 -0700
From: Greg KH <greg@kroah.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        Frank Mori Hess <fmhess@users.sourceforge.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        driverdevel <devel@driverdev.osuosl.org>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] staging: fix comedi NI labpc driver build when
 ISA_DMA_API is not enabled
Message-ID: <20110702210729.GB18538@kroah.com>
References: <20110701160523.5626201d.sfr@canb.auug.org.au>
 <20110701154327.69c5b852.rdunlap@xenotime.net>
 <20110701224604.GA7469@kroah.com>
 <20110702114436.b2b8a70b.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110702114436.b2b8a70b.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 02, 2011 at 11:44:36AM -0700, Randy Dunlap wrote:
> On Fri, 1 Jul 2011 15:46:04 -0700 Greg KH wrote:
> 
> 
> > Ick.
> > Care to make a patch?
> 
> I'd rather that someone who has a strong interest in comedi (or NI labpc)
> do that, but here it is anyway.

Thanks, I'll queue it up next week.

greg k-h
