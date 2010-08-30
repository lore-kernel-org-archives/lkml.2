Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883Ab0H3Frd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 01:47:33 -0400
Received: from freeflow.nu ([178.79.134.28]:55255 "EHLO freeflow.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751551Ab0H3Frb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 01:47:31 -0400
Message-ID: <4C7B45F1.7000503@kernel.org>
Date: Mon, 30 Aug 2010 08:47:29 +0300
From: Pekka Enberg <penberg@kernel.org>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/11] x86: Merge tolerant_fwait()
References: <1283011478-27237-1-git-send-email-brgerst@gmail.com>	<1283011478-27237-4-git-send-email-brgerst@gmail.com>	<AANLkTikXeC--5PuuhmJgxDr8MAg97rC5OecsV3HNPz=g@mail.gmail.com> <AANLkTinZ1viu=MWZUhH6M_ztpzg7yYG-4Rh26PkDyVQ_@mail.gmail.com>
In-Reply-To: <AANLkTinZ1viu=MWZUhH6M_ztpzg7yYG-4Rh26PkDyVQ_@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 8/30/10 3:35 AM, Brian Gerst wrote:
> On Sun, Aug 29, 2010 at 2:32 PM, Pekka Enberg<penberg@kernel.org>  wrote:
>> On Sat, Aug 28, 2010 at 7:04 PM, Brian Gerst<brgerst@gmail.com>  wrote:
>>> Now that 32-bit can handle exceptions from the kernel, switch to using
>>> the 64-bit version of tolerant_fwait() without fnclex.  In the unlikely
>>> event an exception is triggered, it is simply ignored.
>>>
>>> Signed-off-by: Brian Gerst<brgerst@gmail.com>
>> Why is 32-bit able to handle exceptions? Is that part of this series
>> or is it some existing commit in tip or linus?
>>
> Commit e2e75c915de045f0785387dc32f55e92fab0614c merged the 32-bit and
> 64-bit math exception handlers into one, which calls
> fixup_exception().
That could be in the changelog.

Acked-by: Pekka Enberg <penberg@kernel.org>
