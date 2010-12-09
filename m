Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004Ab0LIB01 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 20:26:27 -0500
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:33106 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750928Ab0LIB00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 20:26:26 -0500
Message-ID: <4D002FE5.2070609@euromail.se>
Date: Thu, 09 Dec 2010 02:24:53 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Ping Cheng <pinglinux@gmail.com>,
        Chase Douglas <chase.douglas@canonical.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: mt: Add an envelope tool type
References: <1291721340-22652-1-git-send-email-rydberg@euromail.se> <4CFFC3C2.1080905@canonical.com> <AANLkTikmomm2hd7AAJMTnY+=J2wPyVvodv2Ft0jFe7w2@mail.gmail.com> <20101208235805.GE15294@core.coreip.homeip.net> <4D002CE8.2060803@euromail.se> <20101209011752.GH15294@core.coreip.homeip.net>
In-Reply-To: <20101209011752.GH15294@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.64
X-Scan-Result: No virus found in message 1PQVFe-0008BG-9G.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1PQVFe-0008BG-9G 2434a4171bd8249a84089273cbec4678
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2010 02:17 AM, Dmitry Torokhov wrote:

> On Thu, Dec 09, 2010 at 02:12:08AM +0100, Henrik Rydberg wrote:
>>>>>
>>
>>>>> Is it assumed that the envelop has only two touches comprising it? Or is
>>>>> it any number of touches? If it's any number of touches, how does one
>>>>> know how many touches it is?
>>>>
>>>> Those are good questions. Specifying how many touches are in the
>>>> envelop makes sense. It also covers rectangle as a special case of
>>>> envelop.
>>>
>>> I have a feeling that trying to accomodate non-rectangular, more than 2
>>> point shapes without using native MT data is over-engineering the
>>> problem... Do we have examples other than older generation Elantechs and
>>> Synaptics that need envelope notion?
>>>
>>
>>
>> Those are the ones targeted so far. Maybe appletouch could be added to the list
>> as well. I imagine all drivers will end up using zero, one and two envelope points.
> 
> Even ones that fully support independent finger tracking?
> 


No, sorry, that should read "all drivers in that list". The ones that can detect
individual fingers in space are fine as they are.
