Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751581Ab1HMGWU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 02:22:20 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:33490 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091Ab1HMGWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 02:22:18 -0400
Date: Fri, 12 Aug 2011 23:20:12 -0700 (PDT)
Message-Id: <20110812.232012.2290296405050164118.davem@davemloft.net>
To: rdunlap@xenotime.net
Cc: shemminger@vyatta.com, sfr@canb.auug.org.au, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        sathya.perla@emulex.com, subbu.seetharaman@emulex.com,
        ajit.khaparde@emulex.com
Subject: Re: linux-next: Tree for Aug 12 (benet/be2net)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110812151409.b8af0108.rdunlap@xenotime.net>
References: <20110812135618.a209d9af.rdunlap@xenotime.net>
	<20110812150607.2303e10e@nehalam.ftrdhcpuser.net>
	<20110812151409.b8af0108.rdunlap@xenotime.net>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 12 Aug 2011 23:20:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>
Date: Fri, 12 Aug 2011 15:14:09 -0700

> On Fri, 12 Aug 2011 15:06:07 -0700 Stephen Hemminger wrote:
> 
>> On Fri, 12 Aug 2011 13:56:18 -0700
>> Randy Dunlap <rdunlap@xenotime.net> wrote:
>> 
>> > On Fri, 12 Aug 2011 17:13:11 +1000 Stephen Rothwell wrote:
>> > 
>> > > Hi all,
>> > > 
>> > > [The kernel.org mirroring is being very slow today]
>> > 
>> >   [s.l.o.w.]
>> >  
>> > > The net tree gained a build failure do I used the version from
>> > > next-20110811.
>> > 
>> > 
>> > On i386:
>> > 
>> > drivers/built-in.o: In function `be_rx_eqd_update':
>> > be_main.c:(.text+0x569229): undefined reference to `__udivdi3'
>> > 
>> 
>> Already fixed:
> 
> That's really good news.  It appears to be re-b0rked
> or this patch is not in linux-next yet.

Stephen Rothwell dropped the net-next tree from -next yesterday due to
some other unrelated fallout.
