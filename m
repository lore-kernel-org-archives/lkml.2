Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324Ab2ECNDi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 09:03:38 -0400
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:36923 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751642Ab2ECNDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 09:03:37 -0400
Message-ID: <4FA28200.7020508@marvell.com>
Date: Thu, 3 May 2012 21:02:56 +0800
From: Yilu Mao <ylmao@marvell.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Lu Mao <ylmao@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "Baohua.Song@csr.com" <Baohua.Song@csr.com>,
        "santosh.shilimkar@ti.com" <santosh.shilimkar@ti.com>,
        "robherring2@gmail.com" <robherring2@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v5] ARM: cache-l2x0.c: save the final aux ctrl value for
 resuming
References: <1336046857-24133-1-git-send-email-ylmao@marvell.com> <20120503125955.GE27872@arm.com>
In-Reply-To: <20120503125955.GE27872@arm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2012 08:59 PM, Catalin Marinas wrote:
> On Thu, May 03, 2012 at 01:07:37PM +0100, Yilu Mao wrote:
>> There is a bug if l2x0 controller has been enabled when calling
>> l2x0_init, the aux ctrl register will not be saved in l2x0_saved_regs.
>> Therefore we will use uninitialized l2x0_saved_regs.aux_ctrl for
>> resuming later.
>>
>> In this patch, the aux ctrl value is read and saved after it is
>> initialized. So we have the real value being set for resuming.
>>
>> Signed-off-by: Yilu Mao<ylmao@marvell.com>
>
> Acked-by: Catalin Marinas<catalin.marinas@arm.com>
Hi Catalin,

Thanks for reviewing.
I have another question:
There are a lot of registers in l2x0 controller.
Why we only save so small amount of registers?
Base on l2x0 spec, they suggest to save/restore all of them.

-- 
Thanks.

Best Wishes,
Yilu Mao
