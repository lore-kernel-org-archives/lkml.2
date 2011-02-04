Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105Ab1BDTet (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 14:34:49 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:56971 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538Ab1BDTer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 14:34:47 -0500
Date: Fri, 4 Feb 2011 11:34:26 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: netdev <netdev@vger.kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, netfilter-devel@vger.kernel.org
Subject: Re: linux-next: Tree for February 3 (netfilter)
Message-Id: <20110204113426.5d59522b.randy.dunlap@oracle.com>
In-Reply-To: <20110204111511.1f4d6706.randy.dunlap@oracle.com>
References: <20110203160034.44ae3247.sfr@canb.auug.org.au>
	<20110204111511.1f4d6706.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4D4C54D1.012E:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Feb 2011 11:15:11 -0800 Randy Dunlap wrote:

> On Thu, 3 Feb 2011 16:00:34 +1100 Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > Changes since 20110202:

Oops.  This build error is in 20110204, not Feb. 3.


> When SYSCTL and PROC_FS and NETFILTER_NETLINK are not enabled:
> 
> net/built-in.o: In function `try_to_load_type':
> ip_set_core.c:(.text+0x3ab49): undefined reference to `nfnl_unlock'
> ip_set_core.c:(.text+0x3ab4e): undefined reference to `nfnl_lock'
> net/built-in.o: In function `ip_set_nfnl_put':
> (.text+0x3ab6c): undefined reference to `nfnl_lock'
> net/built-in.o: In function `ip_set_nfnl_put':
> (.text+0x3ab87): undefined reference to `nfnl_unlock'
> net/built-in.o: In function `ip_set_nfnl_get_byindex':
> (.text+0x3abb1): undefined reference to `nfnl_lock'
> net/built-in.o: In function `ip_set_nfnl_get_byindex':
> (.text+0x3abc8): undefined reference to `nfnl_unlock'
> net/built-in.o: In function `ip_set_nfnl_get':
> (.text+0x3abef): undefined reference to `nfnl_lock'
> net/built-in.o: In function `ip_set_nfnl_get':
> (.text+0x3ac00): undefined reference to `nfnl_unlock'
> net/built-in.o: In function `ip_set_sockfn_get':
> ip_set_core.c:(.text+0x3b3a8): undefined reference to `nfnl_lock'
> ip_set_core.c:(.text+0x3b3d0): undefined reference to `nfnl_unlock'
> ip_set_core.c:(.text+0x3b403): undefined reference to `nfnl_lock'
> ip_set_core.c:(.text+0x3b414): undefined reference to `nfnl_unlock'
> net/built-in.o: In function `ip_set_init':
> ip_set_core.c:(.init.text+0xe40): undefined reference to `nfnetlink_subsys_register'
> ip_set_core.c:(.init.text+0xe60): undefined reference to `nfnetlink_subsys_unregister'
> net/built-in.o: In function `ip_set_fini':
> ip_set_core.c:(.exit.text+0x1b2): undefined reference to `nfnetlink_subsys_unregister'
> 
> 
> Full .config file is attached.
> 
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
