Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751323Ab1HMGVZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 02:21:25 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:33473 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792Ab1HMGVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 02:21:24 -0400
Date: Fri, 12 Aug 2011 23:19:09 -0700 (PDT)
Message-Id: <20110812.231909.939460841377364522.davem@davemloft.net>
To: rdunlap@xenotime.net
Cc: sfr@canb.auug.org.au, netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, sathya.perla@emulex.com,
        subbu.seetharaman@emulex.com, ajit.khaparde@emulex.com
Subject: Re: linux-next: Tree for Aug 12 (benet/be2net)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110812135618.a209d9af.rdunlap@xenotime.net>
References: <20110812171311.4d7bb640f38838bf7c34df50@canb.auug.org.au>
	<20110812135618.a209d9af.rdunlap@xenotime.net>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 12 Aug 2011 23:19:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>
Date: Fri, 12 Aug 2011 13:56:18 -0700

> On Fri, 12 Aug 2011 17:13:11 +1000 Stephen Rothwell wrote:
> 
>> Hi all,
>> 
>> [The kernel.org mirroring is being very slow today]
> 
>   [s.l.o.w.]
>  
>> The net tree gained a build failure do I used the version from
>> next-20110811.
> 
> 
> On i386:
> 
> drivers/built-in.o: In function `be_rx_eqd_update':
> be_main.c:(.text+0x569229): undefined reference to `__udivdi3'

This is fixed in the net-next tree already by Eric Dumazet, but
thanks for reporting. :-)
