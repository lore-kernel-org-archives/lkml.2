Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751961Ab2EWEpj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 00:45:39 -0400
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:42081 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751250Ab2EWEph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 00:45:37 -0400
Message-ID: <4FBC6B69.4090405@ti.com>
Date: Wed, 23 May 2012 10:15:29 +0530
From: Rajendra Nayak <rnayak@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.20) Gecko/20110805 Thunderbird/3.1.12
MIME-Version: 1.0
To: Mike Turquette <mturquette@ti.com>
CC: mturquette@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] clk: Add support for power of two type dividers
References: <1337250134-29206-1-git-send-email-rnayak@ti.com> <1337250134-29206-2-git-send-email-rnayak@ti.com> <20120522202657.GC4386@gmail.com>
In-Reply-To: <20120522202657.GC4386@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 May 2012 01:56 AM, Mike Turquette wrote:
> On 20120517-15:52, Rajendra Nayak wrote:
>> Quite often dividers and the value programmed in the
>> register have a relation of 'power of two', something like
>> value	div
>> 0	1
>> 1	2
>> 2	4
>> 3	8...
>>
>> Add support for such dividers as part of clk-divider.
>>
>> The clk-divider flag 'CLK_DIVIDER_POWER_OF_TWO' should be used
>> to define such clocks.
>>
>> Signed-off-by: Rajendra Nayak<rnayak@ti.com>
>
> Hi Rajendra,
>
> This patch looks good to me.  I'll take it into my clk-next branch
> towards 3.6 since I'm done pulling stuff for 3.5.
>
> It's good to see CLK_DIVIDER_POWER_OF_TWO finally get used :-)

great, thanks Mike.

>
> Regards,
> Mike

