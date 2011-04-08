Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757099Ab1DHOk5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 10:40:57 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59301 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab1DHOk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 10:40:56 -0400
Date: Fri, 8 Apr 2011 15:40:51 +0100
From: Jamie Iles <jamie@jamieiles.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Jamie Iles <jamie@jamieiles.com>, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, tglx@linutronix.de, grant.likely@secretlab.ca,
        arnd@arndb.de, nico@fluxnic.net
Subject: Re: [PATCHv2 6/7] basic_mmio_gpio: support different input/output
 registers
Message-ID: <20110408144051.GF2933@pulham.picochip.com>
References: <1302272211-30242-1-git-send-email-jamie@jamieiles.com>
 <1302272211-30242-7-git-send-email-jamie@jamieiles.com>
 <20110408143641.GA25237@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110408143641.GA25237@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 08, 2011 at 06:36:41PM +0400, Anton Vorontsov wrote:
> On Fri, Apr 08, 2011 at 03:16:50PM +0100, Jamie Iles wrote:
> [...]
> > +	res_in = platform_get_resource_byname(pdev, IORESOURCE_MEM, "in");
> > +	if (res_in) {
> > +		bgc->reg_in = bgpio_request_and_map(&pdev->dev, res_in);
> > +		if (!bgc->reg_in)
> > +			return -ENOMEM;
> > +		bgc->gc.get = bgpio_get_in;
> > +	} else {
> > +		bgc->gc.get = bgpio_get_dat;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> >  	return 0;
> >  }
> 
> Hm.. will this compile?

No, I accidentally squashed patches 6 and 7 together then obviously 
didn't split them properly.  I'll fix this (and the spacing around the 
locking and repost).

Sorry!

Jamie
