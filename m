Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004Ab2AWTh4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 14:37:56 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:60926 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751353Ab2AWThz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 14:37:55 -0500
MIME-Version: 1.0
In-Reply-To: <20120123.142355.405932925189446350.davem@davemloft.net>
References: <1327344034.6317.3.camel@joe2Laptop>
	<20120123.135350.756110788533975068.davem@davemloft.net>
	<CA+Dx6HYga9HkwzZNCXc7-q7JvV5PJ2w-QqT4p1zb+upWfn3+Ag@mail.gmail.com>
	<20120123.142355.405932925189446350.davem@davemloft.net>
Date: Tue, 24 Jan 2012 01:07:53 +0530
Message-ID: <CA+Dx6Ha2BoO39oQjemLa-OJ44J5rAuSYBk7dg0iXRjW8t4FSGQ@mail.gmail.com>
Subject: Re: [PATCH/RESEND] drivers/net/ethernet: dev_alloc_skb to netdev_alloc_skb
From: "Pradeep A. Dalvi" <netdev@pradeepdalvi.com>
To: David Miller <davem@davemloft.net>
Cc: joe@perches.com, netdev@vger.kernel.org, hch@lst.de,
        linux-kernel@vger.kernel.org, eric.dumazet@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 12:53 AM, David Miller <davem@davemloft.net> wrote:
> From: "Pradeep A. Dalvi" <netdev@pradeepdalvi.com>
> Date: Tue, 24 Jan 2012 00:43:10 +0530
>
>> On Tue, Jan 24, 2012 at 12:23 AM, David Miller <davem@davemloft.net> wrote:
>>> From: Joe Perches <joe@perches.com>
>>> Date: Mon, 23 Jan 2012 10:40:34 -0800
>>>
>>>> Perhaps you should break this large patch
>>>> into multiple separate patches.
>>>
>>> Agreed, this patch is way too large especially for what is obviously
>>> turning out to be a very non-trivial transformation in some cases
>>> and also new patch submitters should generally avoid large patches
>>> like this.
>>
>> Acked! Will try to separate out trivial & non-trivial changes.
>> Although, still trivial changes would be big enough. And at the same
>> time, splitting changes into 118 patches might turn out to be
>> cumbersome for review.
>
> We didn't say to create 118 patches, we're talking about on the
> order of 4 or 5 patches.

Certainly! Would resubmit the patch splitting across couple of them. Thanks!
