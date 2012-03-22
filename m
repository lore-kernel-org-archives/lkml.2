Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964853Ab2CVFkT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 01:40:19 -0400
Received: from gate.crashing.org ([63.228.1.57]:57683 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755294Ab2CVFkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 01:40:16 -0400
Message-ID: <1332394796.2982.78.camel@pasglop>
Subject: Re: [PATCH 14/17] powerpc: crypto: nx driver code supporting nx
 encryption
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Kent Yoder <key@linux.vnet.ibm.com>, David Miller <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        rcj@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org
Date: Thu, 22 Mar 2012 16:39:56 +1100
In-Reply-To: <20120322033957.GA16914@kroah.com>
References: <1332365297.3858.5.camel@key-ThinkPad-W510>
	 <1332366068.3858.50.camel@key-ThinkPad-W510>
	 <20120321221517.GB30748@kroah.com> <1332381004.2982.65.camel@pasglop>
	 <1332385050.2982.71.camel@pasglop> <20120322033957.GA16914@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-21 at 20:39 -0700, Greg KH wrote:
> On Thu, Mar 22, 2012 at 01:57:30PM +1100, Benjamin Herrenschmidt wrote:
> > +int __vio_register_driver(struct vio_driver *viodrv, struct module *owner,
> > +			const char *mod_name)
> >  {
> >  	viodrv->driver.bus = &vio_bus_type;
> > +	viodrv->driver.name = viodrv->name;
> > +	viodrv->driver.bus = &vio_bus_type;
> > +	viodrv->driver.owner = owner;
> > +	viodrv->driver.mod_name = mod_name;
> 
> Any reason you set .bus twice?

Nope, just a typo. I'll fix it up, when I have feedback from Dave.

Cheers,
Ben.


