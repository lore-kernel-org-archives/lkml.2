Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab2FLGIR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 02:08:17 -0400
Received: from dalsmrelay2.nai.com ([205.227.136.216]:26855 "EHLO
	dalsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954Ab2FLGIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 02:08:15 -0400
Message-ID: <4FD6DC69.2090008@snapgear.com>
Date: Tue, 12 Jun 2012 16:06:33 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Paul Bolle <pebolle@tiscali.nl>, <linux-m68k@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] m68k: remove six unused headers
References: <1339059427.25798.3.camel@x61.thuisdomein> <4FD19B29.4050904@snapgear.com> <CAMuHMdXisLvXAPbbkuYsYH2UZ_DJSyEhKZOL6_4qwuwLzFcEoQ@mail.gmail.com>
In-Reply-To: <CAMuHMdXisLvXAPbbkuYsYH2UZ_DJSyEhKZOL6_4qwuwLzFcEoQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

On 10/06/12 18:40, Geert Uytterhoeven wrote:
> On Fri, Jun 8, 2012 at 8:26 AM, Greg Ungerer<gerg@snapgear.com>  wrote:
>> On 07/06/12 18:57, Paul Bolle wrote:
>>> There are six entirely unused headers in arch/m68k/include/asm. Nothing
>>> includes these headers. And a few tests found no hits for the things
>>> they provide (which makes sense).
>>>
>>> MC68332.h, mac_mouse.h, mcfmbus.h, and mcfne.h are all unused since at
>>> least v2.6.12-rc2 (I didn't bother looking further back than that).
>>
>>
>> Although mcfne.h has been unused for a while I am working on some patches
>> that do use it. No problem for the others.
>
> If I'm not mistaken, that should become mcf8390.h, as "NE2000" means
> "NE2000-compatible 8390-based Ethernet"? Cfr. the mac8390 and zorro8390
> discussions in the previous millennium.

I guess I missed those :-(
I think I see from the code for those under ~/drivers/net/ethernet/8390/
what this may have been about though.

Interestingly one of the ColdFire platforms (the Arnewsh 5206 board)
really did have an ISA NE2000 card fitted to it. Most of the follow
ons that where similar use a Davicom/9000.

I'll modify my work a little to follow the other examples.

Thanks
Greg



------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
