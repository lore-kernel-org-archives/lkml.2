Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343Ab0FDJ7G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 05:59:06 -0400
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:46534 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754014Ab0FDJ7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 05:59:04 -0400
X-Greylist: delayed 1608 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Jun 2010 05:59:04 EDT
Message-ID: <4C08C811.6090709@bu3sch.de>
Date: Fri, 04 Jun 2010 11:32:01 +0200
From: =?ISO-8859-1?Q?Michael_B=FCsch?= <mb@bu3sch.de>
User-Agent: Mozilla/5.0 (X11; U; Linux ppc; en-US; rv:1.9.1.9) Gecko/20100515 Icedove/3.0.4
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linville@tuxdriver.com
Subject: Re: mmotm 2010-06-03-16-36 uploaded
References: <201006040005.o5405Afw023296@imap1.linux-foundation.org>	<20100604101329D.fujita.tomonori@lab.ntt.co.jp>	<20100603183410.bf61f113.akpm@linux-foundation.org> <20100604111434N.fujita.tomonori@lab.ntt.co.jp> (sfid-20100604_041624_219992_FFFFFFFFBCAAF085)
In-Reply-To: <20100604111434N.fujita.tomonori@lab.ntt.co.jp> (sfid-20100604_041624_219992_FFFFFFFFBCAAF085)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2010 04:16 AM, FUJITA Tomonori wrote:
> On Thu, 3 Jun 2010 18:34:10 -0700
> Andrew Morton<akpm@linux-foundation.org>  wrote:
>
>> On Fri, 4 Jun 2010 10:14:27 +0900 FUJITA Tomonori<fujita.tomonori@lab.ntt.co.jp>  wrote:
>>
>>> On Thu, 03 Jun 2010 16:36:51 -0700
>>> akpm@linux-foundation.org wrote:
>>>
>>>> The mm-of-the-moment snapshot 2010-06-03-16-36 has been uploaded to
>>>>
>>>>     http://userweb.kernel.org/~akpm/mmotm/
>>>>
>>>> and will soon be available at
>>>>
>>>>     git://zen-kernel.org/kernel/mmotm.git
>>>>
>>>> It contains the following patches against 2.6.35-rc1:
>>>
>>> (snip)
>>>
>>>> ssb-add-dma_dev-to-ssb_device-structure.patch
>>>> b43legacy-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
>>>> b43-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
>>>> b44-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
>>>> ssb-remove-the-ssb-dma-api.patch
>>>
>>> Is there any reason why the above patches are still in -mm (i.e. not
>>> merged in the previous merge window)?
>>
>> Two lines earlier:
>>
>> # propagate these:
>>
>> is akpm shorthand for "send these through maintainers".
>>
>> I prefer to go that way if the patch isn't urgent, just to get a bit
>> more attention and review.  If the patch has a maintainer ack already
>> then I'll often merge it directly.
>>
>>> I got an ACK on the first patch to ssb core from the ssb maintainer,
>>> ACKs on the second and third to b43legacy and b43 from the maintainer.
>>>
>>> http://marc.info/?t=126621151900002&r=1&w=2
>>
>> And none of the above patches were sent to me with acked-by:s, and
>> nobody sent new acked-by:s, so I didn't know this!
>
> Oh, sorry.
>
>> I guess John is the conduit for all five of the above so I'll send them
>> to him now and he might decide to squeak them into 2.6.35.
>
> Thanks. They aren't urgent. 2.6.26 is fine.
>
>
>> But before I do that, please send me an email telling me who acked each
>> patch and I'll update that info.
>
> The first version included the first, second, third, and forth
> patches' changes:
> http://marc.info/?l=linux-netdev&m=126621140418564&w=2
>
> Michael Buesch<mb@bu3sch.de>  acked:
> http://marc.info/?l=linux-kernel&m=126623288409638&w=2
>
> David S. Miller<davem@davemloft.net>  also acked:
> http://marc.info/?l=linux-netdev&m=126621509421648&w=2
>
> Larry Finger<Larry.Finger@lwfinger.net>  acked the changes to
> b43legacy and b43 (the second and third patches now):
> http://marc.info/?l=linux-kernel&m=126634755930224&w=2

I'm a bit nervous, however, whether these patches are tested on all 
platforms that ssb supports. Especially embedded.
However, there is not a huge problem if a breakage is introduced into 
the mainline kernel here. We hardly use mainline for embedded anyway. 
Some patches are basically always needed.
So from my point of view it is OK to merge these patches, if they are 
tested on i386, x86/64. The rest may be sorted out later in the rc cycle 
(or even -stable, for embedded).

-- 
Greetings Michael.
