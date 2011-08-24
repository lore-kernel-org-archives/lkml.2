Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739Ab1HXRXY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 13:23:24 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:3574 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850Ab1HXRXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 13:23:21 -0400
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
Message-ID: <4E55334A.9030102@broadcom.com>
Date: Wed, 24 Aug 2011 10:22:18 -0700
From: "Jiandong Zheng" <jdzheng@broadcom.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:5.0) Gecko/20110624
 Thunderbird/5.0
MIME-Version: 1.0
To: "Maxin B John" <maxin.john@gmail.com>
cc: "Scott Branden" <sbranden@broadcom.com>,
        "Russell King" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] arm: mach-bcmring: fix build error in dma.c
References: <20110823112128.GA2825@maxin>
 <4E53D8D4.5080208@broadcom.com>
 <CAMhs6Yx6DDA4guyiUEQ6K74iouQcqA5rpvo6iY+Qd_Vdi0GhGg@mail.gmail.com>
In-Reply-To: <CAMhs6Yx6DDA4guyiUEQ6K74iouQcqA5rpvo6iY+Qd_Vdi0GhGg@mail.gmail.com>
X-WSS-ID: 624BEB6D4R01878796-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/23/2011 11:28 PM, Maxin B John wrote:
> On Tue, Aug 23, 2011 at 7:44 PM, Jiandong Zheng<jdzheng@broadcom.com>  wrote:
>> On 8/23/2011 4:21 AM, Maxin B John wrote:
>>>
>>>   CC      arch/arm/mach-bcmring/dma.o
>>>
>> Signed-off-by: Jiandong Zheng<jdzheng@broadcom.com>
>>
>> I have same fix submitted on May 12, which was supposed to be applied soon
>> but seems it wasn't.
>
> Oh.. I wasn't aware of that. Please feel free to ignore this one and
> go ahead with your patch.
>
> Regards,
> Maxin
>
Seems the previous patch was lost. Let us just go ahead with this one in 
order to get it fixed sooner.

