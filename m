Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531Ab1ISNsw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 09:48:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11458 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753266Ab1ISNsv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 09:48:51 -0400
Date: Mon, 19 Sep 2011 09:48:15 -0400
From: Jason Baron <jbaron@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: Arnd Bergmann <arnd@arndb.de>, gregkh@suse.de, joe@perches.com,
        jim.cromie@gmail.com, bvanassche@acm.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, aloisio.almeida@openbossa.org,
        netdev@vger.kernel.org, akpm@linux-foundation.org,
        rdunlap@xenotime.net
Subject: Re: [PATCH ] dynamic_debug: call __netdev_printk only for CONFIG_NET
Message-ID: <20110919134814.GA2658@redhat.com>
References: <cover.1313085588.git.jbaron@redhat.com>
 <5514795fe63ccfd4b3a80283ed04a526abe3c59d.1313085588.git.jbaron@redhat.com>
 <201109011657.02407.arnd@arndb.de>
 <20110901151817.GA14324@redhat.com>
 <20110918082736.GB19444@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110918082736.GB19444@kroah.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 18, 2011 at 01:27:36AM -0700, Greg KH wrote:
> On Thu, Sep 01, 2011 at 11:18:18AM -0400, Jason Baron wrote:
> > On Thu, Sep 01, 2011 at 04:57:02PM +0200, Arnd Bergmann wrote:
> > > __netdev_printk is only defined when CONFIG_NET is set. Since we only need
> > > __dynamic_netdev_dbg for network drivers, we can make it conditional on the
> > > same Kconfig symbol.
> > >
> > 
> > Hi,
> > 
> > Yes, I've posted a fix for this:
> > 
> > https://lkml.org/lkml/2011/8/30/297
> > 
> > Hopefully, it will be pulled in soon.
> 
> As that thread again spun off into confusion, can you please resend the
> end result?
> 
> thanks,
> 
> greg k-h

Hi,

Andrew Morton has pulled these into his -mm tree...so I think the series
should be all set.

Thanks,

-Jason
