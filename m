Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317Ab1G2Hha (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 03:37:30 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:42150 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754848Ab1G2Hh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 03:37:29 -0400
Date: Fri, 29 Jul 2011 00:36:20 -0700 (PDT)
Message-Id: <20110729.003620.1377780539620085743.davem@davemloft.net>
To: stse+lkml@fsing.rootsland.net
Cc: maciej.rutecki@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: IP forwarding regression since 3.0-rc6
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110729T091342.GA.06bf4.stse@fsing.rootsland.net>
References: <20110725T141145.GA.2ae38.stse@fsing.rootsland.net>
	<201107281546.33227.maciej.rutecki@gmail.com>
	<20110729T091342.GA.06bf4.stse@fsing.rootsland.net>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 29 Jul 2011 00:36:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephan Seitz <stse+lkml@fsing.rootsland.net>
Date: Fri, 29 Jul 2011 09:15:46 +0200

> On Thu, Jul 28, 2011 at 03:46:33PM +0200, Maciej Rutecki wrote:
>>I created a Bugzilla entry at
>>https://bugzilla.kernel.org/show_bug.cgi?id=40282
>>for your bug report, please add your address to the CC list in there,
>>thanks!
> 
> Thank you for creating a bug report for me. I have added my address to
> the CC list.
> 
> Shade and sweet water!

I really think this bug will get a lot more traction if you report
it to netdev@vger.kernel.org which is where the networking developers
are actually listening.

They don't look over the bugzilla bugs for networking stuff.
Sometimes people will forward bugzilla entries to them, but that is
the exception rather than the rule.

So if you want this bug properly looked at and fixed in a timely
manner, please engage with netdev@vger.kernel.org  If it just
stays in bugzilla it will likely just rot there until someone
forwards it to the networking developer list.

Thank you.
