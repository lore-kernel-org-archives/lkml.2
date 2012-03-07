Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759472Ab2CGE5y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 23:57:54 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59668 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759431Ab2CGE5x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 23:57:53 -0500
MIME-Version: 1.0
In-Reply-To: <4F56EA49.8070808@gmail.com>
References: <1331090098-25097-1-git-send-email-Barry.Song@csr.com>
 <4F56E0AC.8070501@gmail.com> <CAGsJ_4x4CwD+WAE9d+Xob_tfwqmE6SdBdBd5EbC64XBi4Uzvgg@mail.gmail.com>
 <4F56EA49.8070808@gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 7 Mar 2012 12:57:31 +0800
Message-ID: <CAGsJ_4xJoKGt3+b_3bteoMyeO615pCxFpMpsH4LtvufFNDv6bA@mail.gmail.com>
Subject: Re: [PATCH v3] MM: CMA: add a simple kernel module as the helper to
 test CMA
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Barry Song <Barry.Song@csr.com>, linux-kernel@vger.kernel.org,
        workgroup.linux@csr.com, mina86@mina86.com,
        Barry Song <Baohua.Song@csr.com>, linux-arm-kernel@lists.infradead.org,
        m.szyprowski@samsung.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/3/7 Cong Wang <xiyou.wangcong@gmail.com>:
> On 03/07/2012 12:49 PM, Barry Song wrote:
>>
>> 2012/3/7 Cong Wang<xiyou.wangcong@gmail.com>:
>>>
>>> On 03/07/2012 11:14 AM, Barry Song wrote:
>>>>
>>>>
>>>> From: Barry Song<Baohua.Song@csr.com>
>>>>
>>>> Any write request to /dev/cma_test will let the module to allocate
>>>> memory
>>>> from
>>>> CMA, for example:
>>>>
>>>> 1st time
>>>> $ echo 1024>    /dev/cma_test
>>>> will require cma_test to request 1MB(1024KB)
>>>> 2nd time
>>>> $ echo 2048>    /dev/cma_test
>>>> will require cma_test to request 2MB(2048KB)
>>>>
>>>> Any read request to /dev/cma_test will let the module to free the 1st
>>>> valid
>>>> memory from CMA, for example:
>>>>
>>>> 1st time
>>>> $ cat /dev/cma_test
>>>> will require cma_test to free the 1MB allocated in the first write
>>>> request
>>>> 2nd time
>>>> $ cat /dev/cma_test
>>>> will require cma_test to free the 2MB allocated in the second write
>>>> request
>>>
>>>
>>>
>>> Any reason why using /dev not /proc or /sys?
>>
>>
>> pls note it is just a test module to verify CMA at runtime. it is not
>> important either it is /dev, it is /proc or it is /sys.
>
>
> Why not important? You want it to be merged, don't you?
>
>
>>
>> any way to make things easier, we take that way.
>>
>
> Why /dev interface is easier than /proc and /sys? Confused, actually I think
> /proc or /sys should be easier...

if you think so, pls do that and send v4 with your s-o-b.

-barry
