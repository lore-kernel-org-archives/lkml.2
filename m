Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833Ab0JVHkw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 03:40:52 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:60717 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753557Ab0JVHkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 03:40:51 -0400
Message-ID: <4CC13FFF.7040200@linux.vnet.ibm.com>
Date: Fri, 22 Oct 2010 13:10:47 +0530
From: divya <dipraksh@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100527 Thunderbird/3.0.5
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, benh@kernel.crashing.org,
        linuxppc-dev@ozlabs.org
Subject: Re: BUG with the kernel version 2.6.36-rc1 on power machine
References: <4CC13B2C.7090908@linux.vnet.ibm.com>
In-Reply-To: <4CC13B2C.7090908@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 October 2010 12:50 PM, divya wrote:
> Hi ,
>
> With the latest version of kernel 2.6.36-rc1 running on the power 
> machine, came across the following call trace
>
> BUG: looking up invalid subclass: 31
> turning off the locking correctness validator.
> Call Trace:
> [c00000000e0bfb60] [c0000000000119a0] .show_stack+0x6c/0x16c (unreliable)
> [c00000000e0bfc10] [c0000000000c39b8] .lockdep_init_map+0x194/0x630
> [c00000000e0bfcf0] [c0000000005524f8] .mousedev_create+0xcc/0x234
> [c00000000e0bfda0] [c00000000093fb58] .mousedev_init+0x38/0xa0
> [c00000000e0bfe30] [c0000000000097e4] .do_one_initcall+0xd8/0x1c8
> [c00000000e0bfee0] [c0000000009004ac] .kernel_init+0x23c/0x2f8
> [c00000000e0bff90] [c00000000002ad30] .kernel_thread+0x54/0x70
>
> The config file used for make oldconfig is being attached
>
> Thanks
> Divya
>
>
>
>
I meant 2.6.36-git1(b5153163ed580e) , and not 2.6.36-rc1.
Sorry for the confusion.

Thanks
Divya

