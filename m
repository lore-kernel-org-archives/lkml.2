Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923Ab1KXMAR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 07:00:17 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46579 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192Ab1KXMAQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 07:00:16 -0500
MIME-Version: 1.0
In-Reply-To: <CAF+7xWn5ttZuO89HLqT4T=G8r_y3aOX6Guz0+zv+rZ70LvdG3w@mail.gmail.com>
References: <1322103983.16201.7.camel@phoenix> <20111124103256.GE22232@flint.arm.linux.org.uk>
 <CAF+7xWn5ttZuO89HLqT4T=G8r_y3aOX6Guz0+zv+rZ70LvdG3w@mail.gmail.com>
From: Wan ZongShun <mcuos.com@gmail.com>
Date: Thu, 24 Nov 2011 19:59:53 +0800
Message-ID: <CAKT61h9Y_-j8YWPQ7M=AU1v8noBmxGryRg6N-+uceFvVZrx23Q@mail.gmail.com>
Subject: Re: [PATCH] ARM: add subname parameter to mfp_set_groupg callers
To: axel.lin@gmail.com
Cc: Russell King <rmk@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Grant Likely <grant.likely@secretlab.ca>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/11/24 Axel Lin <axel.lin@gmail.com>:
> 2011/11/24 Russell King <rmk@arm.linux.org.uk>:
>> On Thu, Nov 24, 2011 at 11:06:23AM +0800, Axel Lin wrote:
>>> commit 798681bf "ARM: 7158/1: add new MFP implement for NUC900"
>>> adds subname parameter for mfp_set_groupg.
>>>
>>> Thus add subname parameter to the callers.
>>>
>>> Signed-off-by: Axel Lin <axel.lin@gmail.com>
>>> ---
>>> commit 798681bf is in Russell King's tree,
>>
>> It's in mainline as of 20th November.
>
> Then this patch should be for 3.2. It fixes build errors.
>
>>
>>> I think this patch should route via Russell's tree.
>>> This patch is against linux-next 20111123.
>>
>> Is there a reason why this isn't copied to linux-arm-kernel ?
> Sorry.
> I don't know why scripts/get_maintainer.pl does not suggest to Cc
> linux-arm-kernel
> when I run scripts/get_maintainer.pl against this patch.
>
> Regards,
> Axel
>>
>> --
>> Russell King
>>  Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
>>  maintainer of:
>>
>

Acked-by :Wan Zongshun <mcuos.com@gmail.com>

This is my omit, thanks Alex!

-- 
Wan ZongShun.
www.mcuos.com
