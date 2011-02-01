Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400Ab1BAADO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 19:03:14 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:40809 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867Ab1BAADN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 19:03:13 -0500
Date: Tue, 1 Feb 2011 11:03:07 +1100
From: Simon Horman <horms@verge.net.au>
To: David Miller <davem@davemloft.net>
Cc: randy.dunlap@oracle.com, sfr@canb.auug.org.au, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for January 31 (ip_vs)
Message-ID: <20110201000302.GA9482@verge.net.au>
References: <20110131101829.b842da44.randy.dunlap@oracle.com>
 <20110131211846.GH2389@verge.net.au>
 <20110131225727.GA23992@verge.net.au>
 <20110131.150031.70194609.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110131.150031.70194609.davem@davemloft.net>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 31, 2011 at 03:00:31PM -0800, David Miller wrote:
> From: Simon Horman <horms@verge.net.au>
> Date: Tue, 1 Feb 2011 09:57:28 +1100
> 
> > On Tue, Feb 01, 2011 at 08:18:47AM +1100, Simon Horman wrote:
> >> On Mon, Jan 31, 2011 at 10:18:29AM -0800, Randy Dunlap wrote:
> >> > On Mon, 31 Jan 2011 17:41:13 +1100 Stephen Rothwell wrote:
> >> > 
> >> > > Hi all,
> >> > > 
> >> > > Changes since 20110121:
> >> > > 
> >> > > The net tree lost its build failure.
> >> > 
> >> > 
> >> > When CONFIG_SYSCTL is not enabled:
> >> > 
> >> > net/netfilter/ipvs/ip_vs_core.c:1891: warning: format '%lu' expects type 'long unsigned int', but argument 2 has type 'unsigned int'
> >> > ERROR: "unregister_net_sysctl_table" [net/netfilter/ipvs/ip_vs.ko] undefined!
> >> > ERROR: "register_net_sysctl_table" [net/netfilter/ipvs/ip_vs.ko] undefined!
> >> 
> >> Thanks, I'm looking into it.
> > 
> > On a related note, does IPVS need to handle the case
> > where CONFIG_PROC_FS is not enabled?
> 
> Yes.

Thanks.

I checked and it does seem to compile without CONFIG_PROC_FS
and now also without CONFIG_SYSCTL, I'll send a patch for that right
after I finish this email.

I think that in both cases there is dead code, I'll clean that up next.


