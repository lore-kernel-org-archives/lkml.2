Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759480Ab2CGE4L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 23:56:11 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:51750 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759263Ab2CGEzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 23:55:53 -0500
Message-ID: <4F56EA49.8070808@gmail.com>
Date: Wed, 07 Mar 2012 12:55:37 +0800
From: Cong Wang <xiyou.wangcong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Barry Song <21cnbao@gmail.com>
CC: Barry Song <Barry.Song@csr.com>, linux-kernel@vger.kernel.org,
        workgroup.linux@csr.com, mina86@mina86.com,
        Barry Song <Baohua.Song@csr.com>, linux-arm-kernel@lists.infradead.org,
        m.szyprowski@samsung.com
Subject: Re: [PATCH v3] MM: CMA: add a simple kernel module as the helper
 to test CMA
References: <1331090098-25097-1-git-send-email-Barry.Song@csr.com> <4F56E0AC.8070501@gmail.com> <CAGsJ_4x4CwD+WAE9d+Xob_tfwqmE6SdBdBd5EbC64XBi4Uzvgg@mail.gmail.com>
In-Reply-To: <CAGsJ_4x4CwD+WAE9d+Xob_tfwqmE6SdBdBd5EbC64XBi4Uzvgg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2012 12:49 PM, Barry Song wrote:
> 2012/3/7 Cong Wang<xiyou.wangcong@gmail.com>:
>> On 03/07/2012 11:14 AM, Barry Song wrote:
>>>
>>> From: Barry Song<Baohua.Song@csr.com>
>>>
>>> Any write request to /dev/cma_test will let the module to allocate memory
>>> from
>>> CMA, for example:
>>>
>>> 1st time
>>> $ echo 1024>    /dev/cma_test
>>> will require cma_test to request 1MB(1024KB)
>>> 2nd time
>>> $ echo 2048>    /dev/cma_test
>>> will require cma_test to request 2MB(2048KB)
>>>
>>> Any read request to /dev/cma_test will let the module to free the 1st
>>> valid
>>> memory from CMA, for example:
>>>
>>> 1st time
>>> $ cat /dev/cma_test
>>> will require cma_test to free the 1MB allocated in the first write request
>>> 2nd time
>>> $ cat /dev/cma_test
>>> will require cma_test to free the 2MB allocated in the second write
>>> request
>>
>>
>> Any reason why using /dev not /proc or /sys?
>
> pls note it is just a test module to verify CMA at runtime. it is not
> important either it is /dev, it is /proc or it is /sys.

Why not important? You want it to be merged, don't you?

>
> any way to make things easier, we take that way.
>

Why /dev interface is easier than /proc and /sys? Confused, actually I 
think /proc or /sys should be easier...
