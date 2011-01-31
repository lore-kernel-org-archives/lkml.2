Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731Ab1AaW5e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 17:57:34 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:36941 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754296Ab1AaW5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 17:57:32 -0500
Date: Tue, 1 Feb 2011 09:57:28 +1100
From: Simon Horman <horms@verge.net.au>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, netdev <netdev@vger.kernel.org>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for January 31 (ip_vs)
Message-ID: <20110131225727.GA23992@verge.net.au>
References: <20110131174113.8199f901.sfr@canb.auug.org.au>
 <20110131101829.b842da44.randy.dunlap@oracle.com>
 <20110131211846.GH2389@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110131211846.GH2389@verge.net.au>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 01, 2011 at 08:18:47AM +1100, Simon Horman wrote:
> On Mon, Jan 31, 2011 at 10:18:29AM -0800, Randy Dunlap wrote:
> > On Mon, 31 Jan 2011 17:41:13 +1100 Stephen Rothwell wrote:
> > 
> > > Hi all,
> > > 
> > > Changes since 20110121:
> > > 
> > > The net tree lost its build failure.
> > 
> > 
> > When CONFIG_SYSCTL is not enabled:
> > 
> > net/netfilter/ipvs/ip_vs_core.c:1891: warning: format '%lu' expects type 'long unsigned int', but argument 2 has type 'unsigned int'
> > ERROR: "unregister_net_sysctl_table" [net/netfilter/ipvs/ip_vs.ko] undefined!
> > ERROR: "register_net_sysctl_table" [net/netfilter/ipvs/ip_vs.ko] undefined!
> 
> Thanks, I'm looking into it.

On a related note, does IPVS need to handle the case
where CONFIG_PROC_FS is not enabled?
