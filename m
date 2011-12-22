Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490Ab1LVH0d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 02:26:33 -0500
Received: from dalsmrelay2.nai.com ([205.227.136.216]:22719 "EHLO
	dalsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288Ab1LVH0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 02:26:31 -0500
Message-ID: <4EF2DAC8.3060409@snapgear.com>
Date: Thu, 22 Dec 2011 17:22:48 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
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

On 19/12/11 12:24, Daniel Palmer wrote:
> Sorry for not replying sooner. Too much work :(
>
>> I run on ColdFire parts all the time. Right up to 3.2-rc5 :-)
>> It works great. But I don't have or regularly use any original m68k
>> core hardware. I occasionally compile for the 68328 target, so it
>> will compile, can't be sure if it still runs though.
>
> I did a bit of poking around, I couldn't get the 68328 target to build.. I was
> going to have a play with it in xcopilot. It complains about some linker

Yep, a couple of issues when building for the Palm/Pilot.
I just sent a couple of patches to m68k-linux that fix the main
problems. You will also want to disable CONFIG_FW_LOADER if you
have that enabled.

After that I can compile it all the way (I am building on 3.2-rc6).
No idea if it works though.

Regards
Greg



------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
