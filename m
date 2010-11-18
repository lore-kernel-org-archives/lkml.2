Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758194Ab0KROae (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 09:30:34 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:37041 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757796Ab0KROad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 09:30:33 -0500
Message-ID: <4CE53871.6080004@metafoo.de>
Date: Thu, 18 Nov 2010 15:30:09 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: Anton Vorontsov <cbouatmailru@gmail.com>
CC: rklein@nvidia.com, broonie@opensource.wolfsonmicro.com, achew@nvidia.com,
        olof@lixom.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] POWER: Add gpio charger driver
References: <1287663957-30099-1-git-send-email-lars@metafoo.de> <1287676501-23254-1-git-send-email-lars@metafoo.de> <20101118140522.GD19527@oksana.dev.rtsoft.ru>
In-Reply-To: <20101118140522.GD19527@oksana.dev.rtsoft.ru>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anton Vorontsov wrote:
> On Thu, Oct 21, 2010 at 05:55:01PM +0200, Lars-Peter Clausen wrote:
>> This patch adds a simple driver for chargers indicating their online status
>> through a GPIO pin.
>>
>> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
>>
>> ---
>> Changes since v1
>> * Fix typo in Kconfig
>> * Fix whitespace issues
>> * Add missing includes in the header file
>> * Make the irq field of the driver struct unsigned and assume that 0 is not a
>>   valid irq.
> 
> Applied, thanks!
> 
> But please, look at Mark Brown comments. If they are still
> applicable, the follow up patch would be great.
> 
> Thanks!
> 

Hi

I'll send a follow up patch later today. I think I had one or two other issues on my
list that need to be addressed.
I wanted to wait with v3 until it was clear whether the driver had a chance to be
merged at all.
Do you prefer a v3 of the original patch or an incremental one?

- Lars
