Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792Ab3ADT2q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 14:28:46 -0500
Received: from mail.vyatta.com ([76.74.103.46]:33845 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754060Ab3ADT2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 14:28:43 -0500
Date: Fri, 4 Jan 2013 11:27:16 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        bridge@lists.linux-foundation.org
Subject: Re: linux-next: Tree for Jan 4 (net/bridge)
Message-ID: <20130104112716.596f9085@nehalam.linuxnetplumber.net>
In-Reply-To: <50E72977.7030605@infradead.org>
References: <20130104152814.3a3cf74bdec76cea09d3e134@canb.auug.org.au>
	<50E72977.7030605@infradead.org>
Organization: Vyatta
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 04 Jan 2013 11:11:51 -0800
Randy Dunlap <rdunlap@infradead.org> wrote:

> On 01/03/13 20:28, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20130103:
> > 
> 
> on i386 and x86_64:
> 
>   CC      net/bridge/br_netlink.o
> net/bridge/br_netlink.c: In function 'br_netlink_init':
> net/bridge/br_netlink.c:307:2: error: implicit declaration of function 'br_mdb_init' [-Werror=implicit-function-declaration]
> net/bridge/br_netlink.c:314:2: error: implicit declaration of function 'br_mdb_uninit' [-Werror=implicit-function-declaration]
> cc1: some warnings being treated as errors
> make[3]: *** [net/bridge/br_netlink.o] Error 1
> 
> 
> Full randconfig file is attached.
> 
> 

Problem not observed with current net-next and your configuration.
Probably already fixed.
