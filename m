Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936Ab1DQSIQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 14:08:16 -0400
Received: from www.hansjkoch.de ([178.63.77.200]:44091 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751655Ab1DQSIK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 14:08:10 -0400
Date: Sun, 17 Apr 2011 20:08:01 +0200
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>, Michal Simek <monstr@monstr.eu>,
        devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        john.williams@petalogix.com, linux-kernel@vger.kernel.org,
        w.sang@pengutronix.de
Subject: Re: [PATCH v2] uio/pdrv_genirq: Add OF support
Message-ID: <20110417180801.GA2866@local>
References: <1302774106-32764-1-git-send-email-monstr@monstr.eu>
 <20110414230602.GC2780@local>
 <201104171953.42440.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201104171953.42440.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 17, 2011 at 07:53:42PM +0200, Arnd Bergmann wrote:
> On Friday 15 April 2011, Hans J. Koch wrote:
> > > +#ifdef CONFIG_OF
> > > +/*
> > > + * Empty match table for of_platform binding
> > > + * Select your custom compatible string in format
> > > + * { .compatible = "<compatible string>", },
> > > + */
> > > +static const struct of_device_id __devinitconst uio_of_genirq_match[] = {
> > > +     { /* end of list */ },
> > 
> > doesn't that want a NULL termination?
> > 
> 
> It is NULL terminated, that is the /* end of list */.

Right.

Thanks,
Hans
