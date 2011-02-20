Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428Ab1BTX4F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 18:56:05 -0500
Received: from sncsmrelay2.nai.com ([67.97.80.206]:19618 "EHLO
	sncsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755345Ab1BTX4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 18:56:03 -0500
Message-ID: <4D61A986.3060308@snapgear.com>
Date: Mon, 21 Feb 2011 09:53:42 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Linux/m68k <linux-m68k@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        Steven King <sfking00@yahoo.com>,
        uClinux development list <uclinux-dev@uclinux.org>,
        Greg Ungerer <gerg@uclinux.org>,
        Greg Ungerer <gregungerer@westnet.com.au>
Subject: Re: merge of m68knommu and m68k arch branches?
References: <4D5DB83D.80205@snapgear.com>	<AANLkTin0X-ST=rZqwfCA0i5VGCh5ygYXyZFdndiDgR_2@mail.gmail.com>	<AANLkTim=kQOMyKqOEkw5iQjpGhDf0YGMe1ZTnJZkKfr7@mail.gmail.com>	<4D5EEEBB.7050708@snapgear.com> <AANLkTimmfUJASL47Cs80FJ2mkx3PPvAX57x43nF09tns@mail.gmail.com>
In-Reply-To: <AANLkTimmfUJASL47Cs80FJ2mkx3PPvAX57x43nF09tns@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Feb 2011 23:54:35.0007 (UTC) FILETIME=[869000F0:01CBD159]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Geert,

On 19/02/11 18:39, Geert Uytterhoeven wrote:
> On Fri, Feb 18, 2011 at 23:12, Greg Ungerer<gerg@snapgear.com>  wrote:
>> On 19/02/11 01:24, Geert Uytterhoeven wrote:
>>> On Fri, Feb 18, 2011 at 12:27, Geert Uytterhoeven<geert@linux-m68k.org>
>>>   wrote:
>>>>
>>>> On Fri, Feb 18, 2011 at 01:07, Greg Ungerer<gerg@snapgear.com>    wrote:
>>>>>
>>>>> I would like to put up for discussion a merge of the m68knommu and
>>>>> m68k arch branches.
>>>>>
>>>>> Attached is a script and patch that does a kind of brute force
>>>>> simplistic merge of the directories and files. (Thanks to Stephen King
>>>>> <sfking@fdwdc.com>    for the initial version of this script, and to
>>>>> Sam Ravnborg for the m68k includes merge script this was based on).
>>>>> Nothing outside of the arch/m68k and arch/m68knommu directories is
>>>>> touched, and in the end there is no more arch/m68knommu. To apply you
>>>>> simply run the script from the top of a current kernel git tree (I used
>>>>> 2.6.38-rc5 for testing) and then apply the patch.
>>>>
>>>> Building...
>>>
>>> Builds fine (all test configs), runs on ARAnyM.
>>>
>>> Let's go ahead?
>>
>> What sort of timing do you think makes sense?
>> Is for 2.6.39 too soon?
>
> Personally, I don't mind. 2.6.39 is OK for me. I guess the safest way
> is to let Linus
> execute the script? Before or after the merge window?

Well I was going to construct the merge as a single git commit
(which is equivalent to running this script and applying the patch).
Linus would then just pull this.

The best timing for me is near the end of the merge window.
That way we can both get in any other changes first.

Regards
Greg


------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
