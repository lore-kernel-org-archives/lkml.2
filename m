Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314Ab1COUpW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 16:45:22 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:37901 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758414Ab1COUpU (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 15 Mar 2011 16:45:20 -0400
Date: Tue, 15 Mar 2011 16:45:07 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: linux-next: Tree for March 15 (xen/events.c)
Message-ID: <20110315204507.GA11472@dumpdata.com>
References: <20110315194543.a5d56c0c.sfr@canb.auug.org.au>
 <20110315084429.465cea61.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110315084429.465cea61.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4D7FCFD7.0143,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 15, 2011 at 08:44:29AM -0700, Randy Dunlap wrote:
> On Tue, 15 Mar 2011 19:45:43 +1100 Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > Changes since 20110314:
> > 
> > Dropped tree: xen
> 
> 
> Hm, maybe this is already fixed in the dropped tree?

Nope..
> 
> linux-next-20110315/drivers/xen/events.c:396: error: 'struct irq_data' has no member named 'affinity'
> 
> when CONFIG_SMP is not enabled.

but I got a fixed queue up in xen-two. Thanks for pointing this out!
> 
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
