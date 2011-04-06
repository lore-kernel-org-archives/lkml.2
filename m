Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444Ab1DFQDM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 12:03:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39905 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756151Ab1DFQDK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 12:03:10 -0400
Date: Wed, 6 Apr 2011 08:58:05 -0700
From: Greg KH <gregkh@suse.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Andres Salomon <dilinger@queued.net>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, khali@linux-fr.org,
        ben-linux@fluff.org, Peter Korsgaard <jacmet@sunsite.dk>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        linux-i2c@vger.kernel.org, linux-media@vger.kernel.org,
        netdev@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        Mocean Laboratories <info@mocean-labs.com>
Subject: Re: [PATCH 07/19] timberdale: mfd_cell is now implicitly available
 to drivers
Message-ID: <20110406155805.GA20095@suse.de>
References: <20110202200812.3d8d6cba@queued.net>
 <20110331230522.GI437@ponder.secretlab.ca>
 <20110401112030.GA3447@sortiz-mobl>
 <20110401104756.2f5c6f7a@debxo>
 <BANLkTi=bCd_+f=EG-O=U5VH_ZNjFhxkziQ@mail.gmail.com>
 <20110401235239.GE29397@sortiz-mobl>
 <BANLkTi=bq=OGzXFp7qiBr7x_BnGOWf=DRQ@mail.gmail.com>
 <20110404100314.GC2751@sortiz-mobl>
 <20110405030428.GB29522@ponder.secretlab.ca>
 <20110406152322.GA2757@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110406152322.GA2757@sortiz-mobl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 06, 2011 at 05:23:23PM +0200, Samuel Ortiz wrote:
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -33,6 +33,7 @@ struct class;
>  struct subsys_private;
>  struct bus_type;
>  struct device_node;
> +struct mfd_cell;
>  
>  struct bus_attribute {
>  	struct attribute	attr;
> @@ -444,6 +445,8 @@ struct device {
>  	struct device_node	*of_node; /* associated device tree node */
>  	const struct of_device_id *of_match; /* matching of_device_id from driver */
>  
> +	struct mfd_cell	*mfd_cell; /* MFD cell pointer */
> +

What is a "MFD cell pointer" and why is it needed in struct device?

thanks,

greg k-h
