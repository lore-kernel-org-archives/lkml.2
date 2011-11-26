Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809Ab1KZUtw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 15:49:52 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:39678 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753603Ab1KZUtv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 15:49:51 -0500
Date: Sat, 26 Nov 2011 15:49:39 -0500 (EST)
Message-Id: <20111126.154939.980893642757282901.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: levinsasha928@gmail.com, mpm@selenic.com, cl@linux-foundation.org,
        penberg@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [BUG] 3.2-rc2: BUG kmalloc-8: Redzone overwritten
From: David Miller <davem@davemloft.net>
In-Reply-To: <1322305162.10212.8.camel@edumazet-laptop>
References: <1321870967.8173.1.camel@lappy>
	<1322304878.28191.1.camel@sasha>
	<1322305162.10212.8.camel@edumazet-laptop>
X-Mailer: Mew version 6.4 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sat, 26 Nov 2011 12:49:42 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Sat, 26 Nov 2011 11:59:22 +0100

> Le samedi 26 novembre 2011 à 12:54 +0200, Sasha Levin a écrit :
>> > On Mon, 2011-11-21 at 11:21 +0100, Eric Dumazet wrote:
>> > > 
>> > > Hmm, I forgot to remove the sock_hold(sk) call from dn_slow_timer(),
>> > > here is V2 :
>> > > 
>> > > [PATCH] decnet: proper socket refcounting
>> > > 
>> > > Better use sk_reset_timer() / sk_stop_timer() helpers to make sure we
>> > > dont access already freed/reused memory later.
>> > > 
>> > > Reported-by: Sasha Levin <levinsasha928@gmail.com>
>> > > Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
>> > > ---
>> > 
>> > 
>> > Applied locally and running same tests as before, will update with
>> > results.
>> > 
>> 
>> Looks ok after a couple days of testing.
>> 
>> 	Tested-by: Sasha Levin <levinsasha928@gmail.com>
>> 
> 
> Thanks Sasha !

Applied and queued up for -stable, thanks everyone.
