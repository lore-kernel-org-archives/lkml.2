Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab0CQIWq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 04:22:46 -0400
Received: from mail-fx0-f219.google.com ([209.85.220.219]:61988 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554Ab0CQIWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 04:22:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=W/JNIC+n1gSL9P+VuQJtZOyjp54JdpYa8zB5tpoka25CfKAHu6nvTDOiJxdUOKX7/+
         foXr+KeKnNYpKYo4Xr+NRBt0MojUiuQTTrucHm2SMjl8YirhbuBORSZyK2/ik4xUc0ys
         cHyXwis1GWL2ol8ghpHxg+L9MZtyxzOZgxZfI=
MIME-Version: 1.0
In-Reply-To: <b637ec0b1003161331y680418e0p6549504165a45701@mail.gmail.com>
References: <b637ec0b1003111328u5c1d7d7fw6c76c409740827c7@mail.gmail.com>
	 <71cd59b01003120049n1a9fbbf3qfd37f14f241a7f64@mail.gmail.com>
	 <b637ec0b1003121207g5d29ddb4k338f1768ed1c2759@mail.gmail.com>
	 <71cd59b01003130116h4265769v9e1dae95361629ce@mail.gmail.com>
	 <b637ec0b1003130450n3293ee78wc58e08a9bbcefe17@mail.gmail.com>
	 <71cd59b01003152354h64d18c0fq2083f60e399313c8@mail.gmail.com>
	 <b637ec0b1003161331y680418e0p6549504165a45701@mail.gmail.com>
Date: Wed, 17 Mar 2010 09:22:40 +0100
Message-ID: <71cd59b01003170122h1ef767a3ma186e7ef278d73a1@mail.gmail.com>
Subject: Re: Possible bug in eeepc-laptop.c - EeePC 900
From: Corentin Chary <corentin.chary@gmail.com>
To: Fabio Comolli <fabio.comolli@gmail.com>
Cc: ACPI mailing list <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 16, 2010 at 9:31 PM, Fabio Comolli <fabio.comolli@gmail.com> wrote:
> Hi.
>
> On Tue, Mar 16, 2010 at 7:54 AM, Corentin Chary
> <corentin.chary@gmail.com> wrote:
>> On Sat, Mar 13, 2010 at 1:50 PM, Fabio Comolli <fabio.comolli@gmail.com> wrote:
>>> Well, I'm confused.
>>>
>>> I rebooted with the "vanilla" eeepc-laptop.c and I'm sorry to say that
>>> the situation it's not like the one I described in the post I wrote 2
>>> days ago. Actually the situation with the patch reverted is the same I
>>> have with the patch applied.
>>>
>>> What I mean is that if I boot on AC power /proc/cpuinfo always reports
>>> 900MHz and 1800 bogomips. It I boot on battery /proc/cpuinfo always
>>> reports 630MHz and 1260 bogomips. Plugging / unplugging the AC does
>>> not change the situation. Only reboot does.
>>>
>>> But the cpufv interface does indeed seem to work, as glxgears and
>>> stellarium show the frame rate change accordingly to the powersave /
>>> performance selection.
>>>
>>> So my question is: what does really the cpufv interface do? Is it
>>> supposed to change the processor frequency? Or does it change
>>> something else?
>>>
>>> And if the answer to the latest question is affirmative, why
>>> /proc/cpuinfo seems to ignore it?
>>>
>>> Sorry for the confusion.
>>> Regards,
>>> Fabio
>>>
>>
>> Here is what I can read in your DSDT:
>>
>> When INIT or _Q31 is called, the bios check the the battery is
>> present, and call FSBA(0) or FSBA(1).
>> _Q31 seems to be called by an hotkey, could you run "acpi_listen" and
>> search the hotkey that generate 0x50 or 0x51 ?
>
> This is the output requested.
>
> hotkey ATKD 0000002e 00000000
> hotkey ATKD 0000002f 00000000
> hotkey ATKD 00000030 00000000
> hotkey ATKD 00000012 00000000
> hotkey ATKD 00000013 00000000
> hotkey ATKD 00000014 00000000
> hotkey ATKD 00000015 00000000
> hotkey ATKD 00000010 00000000
> button/sleep SLPB 00000080 00000001
> hotkey ATKD 00000010 00000001

None of thesed generate 0x50 or 0x51, may be somehting else :/



-- 
Corentin Chary
http://xf.iksaif.net
