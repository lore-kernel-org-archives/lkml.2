Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855Ab2AWTYI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 14:24:08 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:57621 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923Ab2AWTYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 14:24:06 -0500
Date: Mon, 23 Jan 2012 14:23:55 -0500 (EST)
Message-Id: <20120123.142355.405932925189446350.davem@davemloft.net>
To: netdev@pradeepdalvi.com
Cc: joe@perches.com, netdev@vger.kernel.org, hch@lst.de,
        linux-kernel@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH/RESEND] drivers/net/ethernet: dev_alloc_skb to
 netdev_alloc_skb
From: David Miller <davem@davemloft.net>
In-Reply-To: <CA+Dx6HYga9HkwzZNCXc7-q7JvV5PJ2w-QqT4p1zb+upWfn3+Ag@mail.gmail.com>
References: <1327344034.6317.3.camel@joe2Laptop>
	<20120123.135350.756110788533975068.davem@davemloft.net>
	<CA+Dx6HYga9HkwzZNCXc7-q7JvV5PJ2w-QqT4p1zb+upWfn3+Ag@mail.gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 23 Jan 2012 11:23:58 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Pradeep A. Dalvi" <netdev@pradeepdalvi.com>
Date: Tue, 24 Jan 2012 00:43:10 +0530

> On Tue, Jan 24, 2012 at 12:23 AM, David Miller <davem@davemloft.net> wrote:
>> From: Joe Perches <joe@perches.com>
>> Date: Mon, 23 Jan 2012 10:40:34 -0800
>>
>>> Perhaps you should break this large patch
>>> into multiple separate patches.
>>
>> Agreed, this patch is way too large especially for what is obviously
>> turning out to be a very non-trivial transformation in some cases
>> and also new patch submitters should generally avoid large patches
>> like this.
> 
> Acked! Will try to separate out trivial & non-trivial changes.
> Although, still trivial changes would be big enough. And at the same
> time, splitting changes into 118 patches might turn out to be
> cumbersome for review.

We didn't say to create 118 patches, we're talking about on the
order of 4 or 5 patches.
