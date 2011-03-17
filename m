Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087Ab1CRACD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 20:02:03 -0400
Received: from kroah.org ([198.145.64.141]:38168 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755716Ab1CRACA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 20:02:00 -0400
Date: Thu, 17 Mar 2011 16:25:03 -0700
From: Greg KH <greg@kroah.com>
To: andy.green@linaro.org
Cc: Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: RFC: Platform data for onboard USB assets
Message-ID: <20110317232503.GA14561@kroah.com>
References: <20110311165642.GA9996@kroah.com>
 <20110317214042.GQ31411@opensource.wolfsonmicro.com>
 <20110317214736.GA29014@kroah.com>
 <201103172333.01474.arnd@arndb.de>
 <20110317225328.GB31581@kroah.com>
 <4D8296D1.9060106@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D8296D1.9060106@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 11:18:41PM +0000, Andy Green wrote:
> On 03/17/2011 10:53 PM, Somebody in the thread at some point said:
> 
> >>Not tested!
> >>
> >>Signed-off-by: Arnd Bergmann<arnd.bergmann@linaro.org>
> >
> ><snip>
> >
> >Very nice.
> >
> >Andy and Mark, would this patch work for you?
> 
> You do realize this untested patch depends on 13 year old vapour
> definition of general usb device tagging in Device Tree that does
> not exist yet?

As you get to create your own device tree for your board, it will then
exist, right?

thanks,

greg k-h
