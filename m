Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932600Ab2LMC1j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 21:27:39 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:33281 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756037Ab2LMC1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 21:27:37 -0500
Date: Wed, 12 Dec 2012 21:27:34 -0500 (EST)
Message-Id: <20121212.212734.917363230032045212.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT] Networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <CA+55aFwzUgxQAze=mYbEx8b61V542tzm06Df=mR1BtYVbJy0mg@mail.gmail.com>
References: <20121212.151116.143443755590581447.davem@davemloft.net>
	<CA+55aFwzUgxQAze=mYbEx8b61V542tzm06Df=mR1BtYVbJy0mg@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 12 Dec 2012 18:15:04 -0800

> On Wed, Dec 12, 2012 at 12:11 PM, David Miller <davem@davemloft.net> wrote:
>>
>> There is one merge conflict to resolve in net/sched/cls_cgroup.c,
>> one commit changes the name of some members to "css_*" (this came
>> from Tejun's tree) and another commit adds an "attach" method.
> 
> There's more than that. The ARM board mess is apparently now affecting
> the networking merges too.
> 
> I fixed it up. Hopefully correctly.
> 
> Also, why does the new SHA1 hmac cookie support default to 'y'?

There are two SCTP HMAC cookie algorithms, MD5 and SHA1.

What used to happen is that you had to choose one at build
time, and then you were stuck with that decision and it was
all that you could use.

Now, it's selectable at run time.

If there's anything you find particularly anti-social about
this, I'm sure we can adjust it.
