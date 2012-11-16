Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948Ab2KPRP3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 12:15:29 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:35033 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245Ab2KPRP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 12:15:28 -0500
Message-ID: <50A674D2.9080403@gmail.com>
Date: Fri, 16 Nov 2012 21:16:02 +0400
From: Igor Mazanov <i.mazanov@gmail.com>
Reply-To: i.mazanov@gmail.com
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel,gmane.linux.ports.arm.omap,gmane.linux.ports.arm.kernel
To: Paul Walmsley <paul@pwsan.com>
CC: mturquette@ti.com, linux-omap@vger.kernel.org, tony@atomide.com,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Remove inline from clock framework function definitions
 to build the kernel with GCC 4.7
References: <50A52134.2010502@gmail.com> <alpine.DEB.2.00.1211151845050.18192@utopia.booyaka.com>
In-Reply-To: <alpine.DEB.2.00.1211151845050.18192@utopia.booyaka.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Walmsley wrote:
> + Mike
> 
> On Thu, 15 Nov 2012, Igor Mazanov wrote:
> 
>>  Remove inline from clock framework function definitions to
>>  build the kernel with GCC 4.7
> 
> sparse warns about this also.
> 
>> Signed-off-by: Igor Mazanov <i.mazanov@gmail.com>
> 
> This one is for Mike to deal with as CCF maintainer; it's out of the hands 
> of the OMAP folks.

Thanks for comments, I'll bear in mind it for the future.

> 
> Acked-by: Paul Walmsley <paul@pwsan.com>
> 
> 
>> ---
>>  include/linux/clk-provider.h |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
>> index c127315..f9f5e9e 100644
>> --- a/include/linux/clk-provider.h
>> +++ b/include/linux/clk-provider.h
>> @@ -335,8 +335,8 @@ const char *__clk_get_name(struct clk *clk);
>>  struct clk_hw *__clk_get_hw(struct clk *clk);
>>  u8 __clk_get_num_parents(struct clk *clk);
>>  struct clk *__clk_get_parent(struct clk *clk);
>> -inline int __clk_get_enable_count(struct clk *clk);
>> -inline int __clk_get_prepare_count(struct clk *clk);
>> +int __clk_get_enable_count(struct clk *clk);
>> +int __clk_get_prepare_count(struct clk *clk);
>>  unsigned long __clk_get_rate(struct clk *clk);
>>  unsigned long __clk_get_flags(struct clk *clk);
>>  int __clk_is_enabled(struct clk *clk);
>> --
>> 1.7.4.4
>>
> 
> 
> - Paul

