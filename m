Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738Ab1FZM66 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 08:58:58 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:46879 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692Ab1FZM5k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 08:57:40 -0400
Date: Sun, 26 Jun 2011 05:57:34 -0700 (PDT)
Message-Id: <20110626.055734.167122034165875195.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: fabio.coatti@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: 2.6.39.2 BUG: unable to handle kernel NULL pointer dereference
From: David Miller <davem@davemloft.net>
In-Reply-To: <1309092147.2532.33.camel@edumazet-laptop>
References: <1309082172.2532.31.camel@edumazet-laptop>
	<BANLkTikhGVYAFEZGS-AZf3CyS4yVN+Acvg@mail.gmail.com>
	<1309092147.2532.33.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 26 Jun 2011 05:57:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Sun, 26 Jun 2011 14:42:27 +0200

> Le dimanche 26 juin 2011 à 13:34 +0200, Fabio Coatti a écrit :
>> 2011/6/26 Eric Dumazet <eric.dumazet@gmail.com>:
>> > Le dimanche 26 juin 2011 à 10:28 +0200, Fabio Coatti a écrit :
>> >> I'm trying to boot with 2.6.39.2 but the process stops somewhere in
>> >> network stack, with a BUG: report.
>> >> I've been able to capture the kernel messages usign netconsole, so be
>> >> patient with poor alignment :)
>> 
>> >
>> > Hi Fabio
>> >
>> > Could you test following patch :
>> >
>> > http://git2.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=6407d74c5106bb362b4087693688afd34942b094
>> >
>> >
>> > This should be included in 2.6.39.3, if you confirm this fixes the
>> > problem.
>> >
>> 
>> Yes, I can confirm that your patch fixes the problem, now running
>> 2.6.39.2 just fine. Many thanks!
> 
> Thanks for testing, David will include this to his stable queue I
> presume.

Yep, I will.
