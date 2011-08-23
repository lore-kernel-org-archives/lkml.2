Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898Ab1HWTC2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 15:02:28 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:53057 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755331Ab1HWTBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 15:01:51 -0400
X-Sasl-enc: 1hHBGswXrsM2pB4cvCv+5TL/4W9ZeglrjadAfusLCi7F 1314126110
Date: Tue, 23 Aug 2011 11:58:05 -0700
From: Greg KH <greg@kroah.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        driverdevel <devel@driverdev.osuosl.org>,
        akpm <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, an Abbott <abbotti@mev.co.uk>,
        ori Hess <fmhess@users.sourceforge.net>
Subject: Re: [PATCH -next] staging: fix comedi build when COMEDI_PCI is not
 enabled
Message-ID: <20110823185805.GA11786@kroah.com>
References: <20110822145304.980529cb921e5f1321c622da@canb.auug.org.au>
 <20110822111314.bf7a526f.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110822111314.bf7a526f.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 22, 2011 at 11:13:14AM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@xenotime.net>
> 
> Fix build when CONFIG_ISA_DMA_API is enabled but
> CONFIG_COMEDI_PCI[_DRIVERS] is not enabled.
> Fixes these build errors:
> 
> drivers/staging/comedi/drivers/ni_labpc.c: In function 'labpc_ai_cmd':
> drivers/staging/comedi/drivers/ni_labpc.c:1351: error: implicit declaration of function 'labpc_suggest_transfer_size'
> drivers/staging/comedi/drivers/ni_labpc.c: At top level:
> drivers/staging/comedi/drivers/ni_labpc.c:1802: error: conflicting types for 'labpc_suggest_transfer_size'
> drivers/staging/comedi/drivers/ni_labpc.c:1351: note: previous implicit declaration of 'labpc_suggest_transfer_size' was here
> 
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> ---
>  drivers/staging/comedi/drivers/ni_labpc.c |    4 +++-

I applied your older patch, which causes this one to not apply.  Is it
still needed as well?

thanks,

greg k-h
