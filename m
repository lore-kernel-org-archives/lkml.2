Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138Ab1IRIdF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 04:33:05 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:42493 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750753Ab1IRIcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 04:32:55 -0400
X-Sasl-enc: 5j2G8Vi2NpA4IVJV4vc5edQl7i5UQOlCAKyhiRNVWFPp 1316334771
Date: Sun, 18 Sep 2011 01:27:36 -0700
From: Greg KH <greg@kroah.com>
To: Jason Baron <jbaron@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>, gregkh@suse.de, joe@perches.com,
        jim.cromie@gmail.com, bvanassche@acm.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, aloisio.almeida@openbossa.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH ] dynamic_debug: call __netdev_printk only for CONFIG_NET
Message-ID: <20110918082736.GB19444@kroah.com>
References: <cover.1313085588.git.jbaron@redhat.com>
 <5514795fe63ccfd4b3a80283ed04a526abe3c59d.1313085588.git.jbaron@redhat.com>
 <201109011657.02407.arnd@arndb.de>
 <20110901151817.GA14324@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110901151817.GA14324@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 01, 2011 at 11:18:18AM -0400, Jason Baron wrote:
> On Thu, Sep 01, 2011 at 04:57:02PM +0200, Arnd Bergmann wrote:
> > __netdev_printk is only defined when CONFIG_NET is set. Since we only need
> > __dynamic_netdev_dbg for network drivers, we can make it conditional on the
> > same Kconfig symbol.
> >
> 
> Hi,
> 
> Yes, I've posted a fix for this:
> 
> https://lkml.org/lkml/2011/8/30/297
> 
> Hopefully, it will be pulled in soon.

As that thread again spun off into confusion, can you please resend the
end result?

thanks,

greg k-h
