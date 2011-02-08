Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751441Ab1BHFAf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 00:00:35 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:60616 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126Ab1BHFAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 00:00:33 -0500
Date: Tue, 8 Feb 2011 14:00:29 +0900
From: Simon Horman <horms@verge.net.au>
To: Chris Ball <cjb@laptop.org>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Ian Molton <ian@mnementh.co.uk>
Subject: Re: [PATCH] [patch v3] tmio_mmc: Improve readability of the output
 of pr_debug_status()
Message-ID: <20110208050029.GB11970@verge.net.au>
References: <1296856076-2387-1-git-send-email-horms@verge.net.au>
 <20110208040555.GA7832@void.printf.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110208040555.GA7832@void.printf.net>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 08, 2011 at 04:05:58AM +0000, Chris Ball wrote:
> Hi Simon,
> 
> On Sat, Feb 05, 2011 at 06:47:56AM +0900, Simon Horman wrote:
> > --- a/drivers/mmc/host/tmio_mmc.h
> > +++ b/drivers/mmc/host/tmio_mmc.h
> 
> Mind rebasing against Linus' tree or mmc-next?  Guennadi has merged
> tmio_mmc.h into tmio_mmc.c there.
> 
> Once the patch applies, I'll merge it into mmc-next with a Reviewed-by:
> line from Guennadi unless anyone objects.

Sure, will do.
