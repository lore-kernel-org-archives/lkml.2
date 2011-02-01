Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533Ab1BAEGm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 23:06:42 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:60907 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789Ab1BAEGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 23:06:40 -0500
Date: Tue, 1 Feb 2011 15:06:37 +1100
From: Simon Horman <horms@verge.net.au>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvs-devel@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Hans Schillstrom <hans@schillstrom.com>,
        Patrick McHardy <kaber@trash.net>
Subject: Re: [GIT PULL nf-next-2.6] IPVS build fixes and clean-ups
Message-ID: <20110201040634.GA2351@verge.net.au>
References: <1296519255-10602-1-git-send-email-horms@verge.net.au>
 <20110131165009.66999952.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110131165009.66999952.randy.dunlap@oracle.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 31, 2011 at 04:50:09PM -0800, Randy Dunlap wrote:
> On Tue,  1 Feb 2011 11:14:11 +1100 Simon Horman wrote:
> 
> > Hi,
> > 
> > This short patch series addresses two linux-next build problems
> > raised by Randy Dunlap:
> > 
> > * net/netfilter/ipvs/ip_vs_core.c:1891: warning: format '%lu' expects type 'long unsigned int', but argument 2 has type 'unsigned int'
> > * ERROR: "unregister_net_sysctl_table" [net/netfilter/ipvs/ip_vs.ko]
> >   ERROR: "register_net_sysctl_table" [net/netfilter/ipvs/ip_vs.ko] undefined!
> > 
> > The remainder of the changset is cleanups that I noticed along the way.
> 
> These 4 patches build successfully for me.
> However, I do see these warnings (sorry I missed them earlier):
> 
> WARNING: net/netfilter/ipvs/ip_vs.o(.init.text+0x161): Section mismatch in reference from the function init_module() to the function .exit.text:ip_vs_sync_cleanup()
> WARNING: net/netfilter/ipvs/ip_vs.o(.init.text+0x161): Section mismatch in reference from the function init_module() to the function .exit.text:ip_vs_sync_cleanup()

Thanks, I'll look into that. I will be travelling for a good portion of the
next day and a bit so I apologise in advance if that delays my next patch.
