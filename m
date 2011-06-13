Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414Ab1FMQkx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 12:40:53 -0400
Received: from mail.perches.com ([173.55.12.10]:2837 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754291Ab1FMQke (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 12:40:34 -0400
Subject: Re: [Xen-devel] [PATCH 1/2] xen: Add
 __attribute__((format(printf... where appropriate
From: Joe Perches <joe@perches.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
In-Reply-To: <20110613163158.GA26322@dumpdata.com>
References: <17ffbd77627a21c05ab9e1a07b5207334291cf01.1307895293.git.joe@perches.com>
	 <20110613163158.GA26322@dumpdata.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Jun 2011 09:40:31 -0700
Message-ID: <1307983231.6189.6.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-13 at 12:31 -0400, Konrad Rzeszutek Wilk wrote:
> On Sun, Jun 12, 2011 at 09:21:13AM -0700, Joe Perches wrote:
> > Use the compiler to verify printf formats and arguments.
> What compiler?

Any supported version of gcc.

>  If this is not included in 3.0 what is the fallout?

Nothing of any import.
nodename won't get printed on an unlikely error message.
I don't think it should go into 3.0.

> >  	err = xenbus_switch_state(dev, XenbusStateConnected);
> >  	if (err)
> > -		xenbus_dev_fatal(dev, err, "switching to Connected state",
> > +		xenbus_dev_fatal(dev, err, "%s: switching to Connected state",
> >  				 dev->nodename);


