Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806Ab1BANY0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 08:24:26 -0500
Received: from stinky.trash.net ([213.144.137.162]:42239 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976Ab1BANYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 08:24:25 -0500
Message-ID: <4D48097B.9000406@trash.net>
Date: Tue, 01 Feb 2011 14:24:11 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100620 Icedove/3.0.5
MIME-Version: 1.0
To: Simon Horman <horms@verge.net.au>
CC: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvs-devel@vger.kernel.org,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Hans Schillstrom <hans@schillstrom.com>
Subject: Re: [GIT PULL nf-next-2.6 v2] IPVS build fixes and clean-ups
References: <1296554868-17002-1-git-send-email-horms@verge.net.au>
In-Reply-To: <1296554868-17002-1-git-send-email-horms@verge.net.au>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01.02.2011 11:07, Simon Horman wrote:
> This short patch series addresses two linux-next build problems
> raised by Randy Dunlap:
> 
> * net/netfilter/ipvs/ip_vs_core.c:1891: warning: format '%lu' expects type 'long unsigned int', but argument 2 has type 'unsigned int'
> * ERROR: "unregister_net_sysctl_table" [net/netfilter/ipvs/ip_vs.ko]
>   ERROR: "register_net_sysctl_table" [net/netfilter/ipvs/ip_vs.ko] undefined!
> * WARNING: net/netfilter/ipvs/ip_vs.o(.init.text+0x161): Section mismatch in reference from the function init_module() to the function .exit.text:ip_vs_sync_cleanup()
> 
> The remainder of the changsets are cleanups that I noticed along the way.
> 
> The changes are available at
> git://git.kernel.org/pub/scm/linux/kernel/git/horms/lvs-test-2.6.git master
> 
> They are currently compile-tested only.

Just to avoid any confusion, do you want me to pull these patches
already?
