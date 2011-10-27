Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750827Ab1J0EPJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 00:15:09 -0400
Received: from sncsmrelay2.nai.com ([67.97.80.206]:40345 "EHLO
	sncsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744Ab1J0EPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 00:15:07 -0400
Message-ID: <4EA8DAF4.6090808@snapgear.com>
Date: Thu, 27 Oct 2011 14:15:48 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
        lkml <linux-kernel@vger.kernel.org>, Greg Ungerer <gerg@uclinux.org>,
        uClinux development list <uclinux-dev@uclinux.org>
Subject: Re: [PATCH 6/8] clocksource: m86k: Convert to clocksource_register_hz/khz
References: <4ea6fbe8.43310e0a.592c.5416SMTPIN_ADDED@mx.google.com>	 <CAMuHMdWVdaq+uuCLxuN0EsmJiQdyr9xWpqg6oAeHg3NP_u2V8g@mail.gmail.com>	 <1319568370.17505.21.camel@work-vm> <4EA79629.3040403@snapgear.com> <1319651860.23224.3.camel@work-vm>
In-Reply-To: <1319651860.23224.3.camel@work-vm>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

On 27/10/11 03:57, john stultz wrote:
> On Wed, 2011-10-26 at 15:10 +1000, Greg Ungerer wrote:
>> Hi John,
>>
>> On 26/10/11 04:46, john stultz wrote:
>>> Updated to merge the valid bits of the two m68k patches.
>>>
>>> This converts the m86k clocksources to use clocksource_register_hz/khz
>>>
>>> This is untested, so any assistance in testing would be appreciated!
>>
>> This looks good. I test compiled across all targets these files affect.
>> And run tested on ColdFire/5208 (which uses pit.c).
>
> Thanks for testing! I really appreciate it!
>
>>
>>> CC: Geert Uytterhoeven<geert@linux-m68k.org>
>>> CC: Greg Ungerer<gerg@uclinux.org>
>>> Signed-off-by: John Stultz<johnstul@us.ibm.com>
>>
>> Acked-by: Greg Ungerer<gerg@uclinux.org>
>>
>> Do you want me to push these via the m68knommu git tree?
>
> I'd prefer it go through either one of the m68k trees.

Ok, I have put it int the m68knommu git tree (since all the changes
apply to non-mmu versions of the m68k).

Thanks
Greg


------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
