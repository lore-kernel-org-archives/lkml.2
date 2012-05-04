Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760633Ab2EDXYQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 19:24:16 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:57294 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756783Ab2EDXYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 19:24:15 -0400
X-Sasl-enc: WeGIHiWPBstBupF04k77qomKkdw35bvLYbZDYQvda5TP 1336173854
Date: Fri, 4 May 2012 16:24:13 -0700
From: GregKH <greg@kroah.com>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: H Hartley Sweeten <hartleys@visionengravers.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] w1: w1_ds2408.c: quite sparse noise about using plaing
 integer as NULL pointer
Message-ID: <20120504232413.GA9815@kroah.com>
References: <201205021702.07694.hartleys@visionengravers.com>
 <20120503180202.GC13988@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120503180202.GC13988@ioremap.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2012 at 10:02:02PM +0400, Evgeniy Polyakov wrote:
> On Wed, May 02, 2012 at 05:02:07PM -0700, H Hartley Sweeten (hartleys@visionengravers.com) wrote:
> > NULL not 0 should be used with pointers. Just remove the offending
> > lines since they will default to NULL anyway.
> > 
> > Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> > Cc: Evgeniy Polyakov <zbr@ioremap.net>
> 
> Looks good, thank you
> Greg, please pull it into your tree or should it be forwarded to
> janitor list?

I'll take it, thanks.

greg k-h
