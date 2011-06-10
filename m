Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757946Ab1FJSXq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 14:23:46 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:34652 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757901Ab1FJSXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 14:23:45 -0400
Message-ID: <4DF260F4.1020603@metafoo.de>
Date: Fri, 10 Jun 2011 20:22:44 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110505 Icedove/3.0.11
MIME-Version: 1.0
To: Mike Frysinger <vapier.adi@gmail.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, uclinux-dist-devel@blackfin.uclinux.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        device-drivers-devel@blackfin.uclinux.org
Subject: Re: [Device-drivers-devel] [PATCH 1/3] ASoC: Add ADAU1701 codec driver
References: <1307726331-28618-1-git-send-email-lars@metafoo.de> <BANLkTimLAfEj+tgNMWjTsanccgfEt9UW1g@mail.gmail.com> <4DF25AF5.6070909@metafoo.de> <BANLkTikSqdHDzQUZdh87YX3y+=GtKDe27g@mail.gmail.com> <BANLkTingQSnzmhqS8HOqmeQjRMRVAE020w@mail.gmail.com>
In-Reply-To: <BANLkTingQSnzmhqS8HOqmeQjRMRVAE020w@mail.gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2011 08:15 PM, Mike Frysinger wrote:
> On Fri, Jun 10, 2011 at 14:08, Mike Frysinger wrote:
>> On Fri, Jun 10, 2011 at 13:57, Lars-Peter Clausen wrote:
>>> On 06/10/2011 07:43 PM, Mike Frysinger wrote:
>>>> On Fri, Jun 10, 2011 at 13:18, Lars-Peter Clausen wrote:
>>>>> +MODULE_AUTHOR("Lars-Peter Clausen <lars@metafoo.de>");
>>>>
>>>> did you actually rewrite this thing from scratch ?  seems like you
>>>> should keep Cliff as the author in git/MODULE_AUTHOR, and then add
>>>> your name to the s-o-b list and this macro.
>>>
>>> Not from scratch, but I guess except for the register definitions and the
>>> copyright header not much of the original driver is left:
>>> sound/soc/codecs/adau1701.c |  662 ++++++++++++++++++++++++-------------------
>>>  1 files changed, 371 insertions(+), 291 deletions(-)
>>
>> based purely on LoC, Cliff wrote 467, so you took that and punted 291
>> (62%) and then added 371.  that leaves the final file with 32% Cliff
>> and 68% you.
>>
>> however, some of that was register renaming and shuffling between the
>> adau1701.c and adau1701.h, and it's easier to start with a base and
>> clean up than from scratch.
>>
>> so i'm definitely not comfortable dropping Cliff's completely from the
>> file and the log (which means he needs to be readded and made sure to
>> be retained in all the other ADAU drivers going forward), and i'm not
>> entirely sold about changing of the Author field in the git commit.
>>
>> don't get me wrong ... i'm not a fanboi of Cliff or something, i just
>> think credit is due to him for his work.
>
You have both the orignal driver and the new driver, so you can do the diff for
yourself. You see that the lines unchanged are basically boilerplate code and
stuff that you'll find in any ASoC driver. The diff to any random ASoC driver
called adau1701.

But of course if you want to see his name as the author, you get his name as
the author.

> to be clear, i'm like 50/50 on the git author field.  maybe someone
> else here has an opinion, or you feel strongly enough that your
> rewrite supersedes his seeding work.  but please send a v2 with
> updated source/changelog with his name in it.
His name is already in the copyright header.

- Lars


