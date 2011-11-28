Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960Ab1K1WIt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 17:08:49 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:59174 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048Ab1K1WIs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 17:08:48 -0500
Date: Mon, 28 Nov 2011 17:08:40 -0500 (EST)
Message-Id: <20111128.170840.1847881572380941723.davem@davemloft.net>
To: will.deacon@arm.com
Cc: eric.dumazet@gmail.com, mmaruseac@ixiacom.com,
        linux-kernel@vger.kernel.org
Subject: Re: NULL pointer dereference in mainline and next
From: David Miller <davem@davemloft.net>
In-Reply-To: <20111128143558.GC2911@mudshark.cambridge.arm.com>
References: <20111128141846.GA2911@mudshark.cambridge.arm.com>
	<1322490804.2292.34.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	<20111128143558.GC2911@mudshark.cambridge.arm.com>
X-Mailer: Mew version 6.4 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 28 Nov 2011 14:08:42 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Will Deacon <will.deacon@arm.com>
Date: Mon, 28 Nov 2011 14:35:58 +0000

> On Mon, Nov 28, 2011 at 02:33:24PM +0000, Eric Dumazet wrote:
>> Le lundi 28 novembre 2011 à 14:18 +0000, Will Deacon a écrit :
>> > Hello,
>> > 
>> > Commit f04565dd ("dev: use name hash for dev_seq_ops") requires a struct
>> > dev_iter_state to be allocated for the seq_file->private member, as that is
>> > used to implement the name hash.
>> > 
>> > Unfortunately, the dev_mcast code wasn't updated and so only allocates space
>> > for a seq_net_private, leading to the following NULL dereference (removed
>> > static inline annotations to get sane backtrace):
> 
> [...]
> 
>> Anton Blanchard already provided a fix for this problem.
>> 
>> http://patchwork.ozlabs.org/patch/127931/
> 
> Ok, great - as long as it gets fixed!

Please in the future report networking bugs to netdev@vger.kernel.org as that
will reach the largest number of networking developers.

Thanks.
