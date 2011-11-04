Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570Ab1KDNR6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 09:17:58 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:49542 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014Ab1KDNR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 09:17:57 -0400
Message-ID: <4EB3E5F6.7060705@samsung.com>
Date: Fri, 04 Nov 2011 22:17:42 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110928 Fedora/3.1.15-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.15
MIME-Version: 1.0
To: "Koul, Vinod" <vinod.koul@intel.com>
CC: Arnd Bergmann <arnd@arndb.de>, Kukjin Kim <kgene.kim@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: arm-soc samsung patches blocked on dmaengine patches
References: <201111041400.44486.arnd@arndb.de> <438BB0150E931F4B9CE701519A446301087AA53D66@bgsmsx502.gar.corp.intel.com>
In-Reply-To: <438BB0150E931F4B9CE701519A446301087AA53D66@bgsmsx502.gar.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/11 22:06, Koul, Vinod wrote:
>> Hi Vinod and Kukjin,
>>
>> Right now, all the patches from the arm-soc tree are merged into 3.2, but the
>> samsung/cleanup and samsung/devel series are missing because they depend on
>> patches in the dmaengine tree. I'm not sure about the status of that tree,
>> but I didn't see a pull request for them yet.
>>
>> Should I just submit the samsung tree with the dmaengine patches included,
>> or keep waiting?
>>
> Arnd,
>
> I have already sent pull request to Linus on Monday[1], still waiting for
> these to get merged
>
Arnd,

So I think you can send them to Linus.

And as a note, I sent next-samsung-devel-4 which includes supporting 
EXYNOS4 DT and reorganization mach-exynos and something to you. I hope 
you can pick them up with others too. If any problems, please let me know.

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.
