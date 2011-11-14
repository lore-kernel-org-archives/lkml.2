Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714Ab1KNOC7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 09:02:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29496 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752982Ab1KNOC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 09:02:57 -0500
Date: Mon, 14 Nov 2011 09:02:53 -0500
From: Josh Boyer <jwboyer@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: jpirko@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] ip6_tunnel: copy parms.name after register_netdevice
Message-ID: <20111114140253.GA4096@zod.bos.redhat.com>
References: <20111111011023.GE2170@zod.bos.redhat.com>
 <20111114.002456.1590067179487443754.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111114.002456.1590067179487443754.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 14, 2011 at 12:24:56AM -0500, David Miller wrote:
> From: Josh Boyer <jwboyer@redhat.com>
> Date: Thu, 10 Nov 2011 20:10:23 -0500
> 
> > @@ -288,6 +288,8 @@ static struct ip6_tnl *ip6_tnl_create(struct net *net, struct ip6_tnl_parm *p)
> >  
> >  	if ((err = register_netdevice(dev)) < 0)
> >  		goto failed_free;
> > +	
> > +	strcpy(t->parms.name, dev->name);
> 
> Trailing whitespace on that blank line you're adding.

Ugh.  Forgot to run checkpatch.  Apologies.

> I fixed this up, applied, and queued up for -stable, thanks.

Thank you.

josh
