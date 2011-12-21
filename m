Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671Ab1LULtl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 06:49:41 -0500
Received: from dalsmrelay2.nai.com ([205.227.136.216]:24492 "EHLO
	dalsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753641Ab1LULte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 06:49:34 -0500
Message-ID: <4EF1C7AF.8040801@snapgear.com>
Date: Wed, 21 Dec 2011 21:49:03 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Daniel Palmer <me@danielpalmer.co.uk>
CC: Geert Uytterhoeven <geert@linux-m68k.org>, <linux-kernel@vger.kernel.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>,
        uClinux development list <uclinux-dev@uclinux.org>
Subject: Re: Porting m68k/nommu to a new board.
References: <201112152137.29195.me@danielpalmer.co.uk> <CAMuHMdU+VCVxnawb8DHmZp1EfBGW6T5D0WyXRXpo8bj1bJZ+pg@mail.gmail.com> <4EEB23FD.9090904@snapgear.com> <201112181824.56271.me@danielpalmer.co.uk>
In-Reply-To: <201112181824.56271.me@danielpalmer.co.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On 12/19/2011 12:24 PM, Daniel Palmer wrote:
> Sorry for not replying sooner. Too much work :(

No problem :-)


>> I run on ColdFire parts all the time. Right up to 3.2-rc5 :-)
>> It works great. But I don't have or regularly use any original m68k
>> core hardware. I occasionally compile for the 68328 target, so it
>> will compile, can't be sure if it still runs though.
>
> I did a bit of poking around, I couldn't get the 68328 target to build.. I was
> going to have a play with it in xcopilot. It complains about some linker
> section missing .. but I started hacking it up anyway.. at the moment m68328
> depends on m68000 which in turn causes the 68328 platform stuff to build.
> So I worked that a little so that 68000 is its own target that builds with
> some minimal startup code (so I can dump the resulting image into my emulator
> and see how far it gets.. I have a gdbserver in my emulator so I can fully see
> whats happening). I haven't managed to get an image out of it yet.. but I will
> have another go at the weekend.

Sounds good. Keep us posted on how you go.


> I'm going to get an old palm pilot off of ebay and see if I can get the 68328
> target running too.

Yeah, would be really nice to know what state the 68328 code is in.

I will compile it again too, and see if anything is obviously broken at
the moment.

Regards
Greg


------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close,                            FAX:         +61 7 3891 3630
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
