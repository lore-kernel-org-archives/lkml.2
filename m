Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001Ab2CGFRe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 00:17:34 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61799 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab2CGFRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 00:17:32 -0500
MIME-Version: 1.0
In-Reply-To: <4F56ED9D.3000504@gmail.com>
References: <1331090098-25097-1-git-send-email-Barry.Song@csr.com>
 <4F56E0AC.8070501@gmail.com> <CAGsJ_4x4CwD+WAE9d+Xob_tfwqmE6SdBdBd5EbC64XBi4Uzvgg@mail.gmail.com>
 <4F56EA49.8070808@gmail.com> <CAGsJ_4xJoKGt3+b_3bteoMyeO615pCxFpMpsH4LtvufFNDv6bA@mail.gmail.com>
 <4F56EBA6.6000704@gmail.com> <CAGsJ_4ypegMQVf0Xet1T5sLaaEDGh5s1Vi6w4t_UQSZp7nYQuQ@mail.gmail.com>
 <4F56ED9D.3000504@gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 7 Mar 2012 13:17:12 +0800
Message-ID: <CAGsJ_4x9hGDh+PgrvtXqp-bdbPHABz1ErHGdvFQAr0m9RYM8Vw@mail.gmail.com>
Subject: Re: [PATCH v3] MM: CMA: add a simple kernel module as the helper to
 test CMA
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Barry Song <Barry.Song@csr.com>, linux-kernel@vger.kernel.org,
        workgroup.linux@csr.com, mina86@mina86.com,
        Barry Song <Baohua.Song@csr.com>, linux-arm-kernel@lists.infradead.org,
        m.szyprowski@samsung.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/3/7 Cong Wang <xiyou.wangcong@gmail.com>:
> On 03/07/2012 01:05 PM, Barry Song wrote:
>>
>> 2012/3/7 Cong Wang<xiyou.wangcong@gmail.com>:
>>>
>>> On 03/07/2012 12:57 PM, Barry Song wrote:
>>>>
>>>>
>>>>
>>>> if you think so, pls do that and send v4 with your s-o-b.
>>>>
>>>
>>> This is not a good attitude, nor helps your patch to be merged...
>>>
>>> Be collaborative.
>>
>>
>> some people like focusing on trivial things. i said i really didn't
>> care about the details whether it is /dev, /proc, /sys.
>> if you like a /proc, pls do it by yourself and i will agree. but i
>> will not waste my time on that.
>
>
> This is definitely not trivial... What's more, kernel developers *do* care
> about trivial things (trivial@kernel.org).

that is definitely trivial as we are talking about things in a test
module. and we are not talking about any bug in the test module as
well.

>
> We are trying to make your patch perfect, you just refused, sigh...

pls note i just care about people have an easy way to test the newest
contiguous memory allocator. pls be focusing on valuable things.

i said if you like /proc, pls do and i agree.

-barry
