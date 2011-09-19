Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756633Ab1ISBDu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 21:03:50 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:52690 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab1ISBDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 21:03:49 -0400
Date: Sun, 18 Sep 2011 21:03:44 -0400 (EDT)
Message-Id: <20110918.210344.570661374586887894.davem@davemloft.net>
To: david.ward@ll.mit.edu
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT] Networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <4E76864D.4080907@ll.mit.edu>
References: <20110918.022125.1554085675403900813.davem@davemloft.net>
	<CA+55aFxc1tMCXKBV33PVD5BybTLBpfJAEcObvoQwbwqbKOsp7g@mail.gmail.com>
	<4E76864D.4080907@ll.mit.edu>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 18 Sep 2011 18:03:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ward <david.ward@ll.mit.edu>
Date: Sun, 18 Sep 2011 20:01:17 -0400

> On 09/18/2011 02:06 PM, Linus Torvalds wrote:
>> 2011/9/17 David Miller<davem@davemloft.net>:
>>> dpward (2):
>>>       net: Make flow cache namespace-aware
>>>       net: Handle different key sizes between address families in flow cache
>>>
>>> nhorman (1):
>>>       net: don't clear IFF_XMIT_DST_RELEASE in ether_setup
>>>
>>> rajan.aggarwal85@gmail.com (1):
>>>       net/can/af_can.c: Change del_timer to del_timer_sync
>> Guys, if somebody has such a broken email setup that they don't even
>> show their own name, don't take patches from them.
> 
> At least in my case, that is Patchwork's fault.  My name only started
> showing up like that in commits after I registered for an account
> (http://patchwork.ozlabs.org/register/), and I don't see any way to
> change the way my name appears in the Patchwork profile options.
> 
> The emails I sent to the netdev list showed my full name; see:
> http://marc.info/?l=linux-netdev&m=131527867326729&w=2
> http://marc.info/?l=linux-netdev&m=131527879226819&w=2

I hope some mechanism can be created to undo this behavior.
