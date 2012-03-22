Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136Ab2CVLSW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 07:18:22 -0400
Received: from mail.us.es ([193.147.175.20]:59454 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250Ab2CVLST (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 07:18:19 -0400
Date: Thu, 22 Mar 2012 12:18:12 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: linux-next: Tree for Mar 21 (netfilter: xt_LOG.c)
Message-ID: <20120322111812.GA16632@1984>
References: <20120321183906.b901645a8e4b68fdf1ad8754@canb.auug.org.au>
 <4F6A7824.50606@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F6A7824.50606@xenotime.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

On Wed, Mar 21, 2012 at 05:53:56PM -0700, Randy Dunlap wrote:
> On 03/21/2012 12:39 AM, Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > Reminder: please do not add stuff destined for v3.5 to linux-next
> > included trees/branches until after v3.4-rc1 has been released.
> > 
> > Changes since 20120320:
> 
> on x86_64:
> 
> xt_LOG.c:(.text+0x6962e): undefined reference to `ip6t_ext_hdr'
> 
> Full randconfig file is attached.

I'll push this to mainstream asap.

https://lkml.org/lkml/2012/3/10/68

Sorry, I forgot to make it.

Thanks.
