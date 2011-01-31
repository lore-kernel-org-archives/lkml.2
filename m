Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400Ab1AaLP1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 06:15:27 -0500
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:51187 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751950Ab1AaLP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 06:15:26 -0500
Message-ID: <4D4699A7.90801@stericsson.com>
Date: Mon, 31 Jan 2011 12:14:47 +0100
From: Linus Walleij <linus.walleij@stericsson.com>
Organization: ST-Ericsson SA
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Thunderbird/3.0.10
MIME-Version: 1.0
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: DMA40 improvements
References: <1295950715-22340-1-git-send-email-linus.walleij@stericsson.com> <AANLkTikQye0k2kE7WjMjPkxuL+1C0YZZFdas1Ttf_jGn@mail.gmail.com>
In-Reply-To: <AANLkTikQye0k2kE7WjMjPkxuL+1C0YZZFdas1Ttf_jGn@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2011 07:17 AM, Dan Williams wrote:
> On Tue, Jan 25, 2011 at 2:18 AM, Linus Walleij
> <linus.walleij@stericsson.com>  wrote:
>    
>> Hi Dan,
>>
>> Here is a number of DMA40 hardening patches, and at last a
>> cyclic DMA implementation.
>>
>>      
> Hi Linus when sending large sets of patches please include a few more
> sentences of summary, a shortlog, and a diffstat  (similar to the info
> git request-pull produces).  The former gives me a better idea of what
> I am looking at, the latter two help me confirm that I applied what
> you expected in the right order.
>    

OK I know I've been bad at this, I'll learn...

>  I currently have:
>
>  Rabin Vincent (32):
>        dma40: make init function static
>        dma40: ensure event lines get enabled
>        dma40: remove "hardware link with previous jobs" code
>        dma40: use helper for channel registers base
>        dma40: use helpers for channel type check
>        dma40: use helpers for error functions
>        dma40: fix comment to refer to SOCs rather than boards
>        dma40: allow realtime and priority for event lines
>        dma40: remove unnecessary ALIGN()s
>        dma40: use sg_dma_address() instead of sg_phys()
>        dma40: fix DMA API usage for LCLA
>        dma40: fix DMA API usage for LLIs
>        dma40: remove unnecessary casts
>        dma40: implement prep_memcpy as a wrapper around memcpy_sg
>        dma40: combine desc init functions
>        dma40: combine duplicated d40_pool_lli_alloc() calls
>        dma40: remove duplicated dev addr code
>        dma40: combine mem and slave sg-to-lli functions
>        dma40: remove export of stedma40_memcpy_sg
>        dma40: combine mem and slave prep_sg functions
>        dma40: move lli_load to main source file
>        dma40: combine duplicated code in log_sg_to_dev
>        dma40: unify d40_log_sg_to_lli funcs for mem and slave
>        dma40: pass the info pointer all the way to reduce argument count
>        dma40: unify src/dst addr check
>        dma40: make d40_log_buf_to_lli static
>        dma40: use flags to reduce parameter count
>        dma40: extract lcla code into separate function
>        dma40: handle failure to allocate first LCLA
>        dma40: fix DMA_SG capability and channels
>        dma40: stop ongoing transfers in DMA_TERMINATE_ALL
>        dma40: cyclic xfer support
>
>   arch/arm/plat-nomadik/include/plat/ste_dma40.h |   22 +-
>   drivers/dma/ste_dma40.c                        | 1402 +++++++++++-------------
>   drivers/dma/ste_dma40_ll.c                     |  218 ++---
>   drivers/dma/ste_dma40_ll.h                     |   66 +-
>   4 files changed, 761 insertions(+), 947 deletions(-)

This matches my topic branch 100%, so it's correct.

Thanks!
Linus Walleij

