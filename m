Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842Ab0LITTI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 14:19:08 -0500
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:50717 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752695Ab0LITTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 14:19:06 -0500
Message-ID: <4D0129B9.9070103@euromail.se>
Date: Thu, 09 Dec 2010 20:10:49 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Jiri Kosina <jkosina@suse.cz>, linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] input: mt updates for 2.6.38
References: <4CFF49BC.8030202@euromail.se> <20101209085814.GA8821@core.coreip.homeip.net> <4D011EA3.2000905@euromail.se> <20101209184940.GB23781@core.coreip.homeip.net>
In-Reply-To: <20101209184940.GB23781@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.200.95
X-Scan-Result: No virus found in message 1PQltB-0005wa-66.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1PQltB-0005wa-66 d1d54265384d7e2c3a90f1b60a0f4d79
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2010 07:49 PM, Dmitry Torokhov wrote:

> On Thu, Dec 09, 2010 at 07:23:31PM +0100, Henrik Rydberg wrote:
>> On 12/09/2010 09:58 AM, Dmitry Torokhov wrote:
>>
>>> On Wed, Dec 08, 2010 at 10:02:52AM +0100, Henrik Rydberg wrote:
>>>> Dmitry,
>>>>
>>>> Please pull from
>>>>
>>>>   git://git.kernel.org/pub/scm/linux/kernel/git/rydberg/input-mt.git next
>>>>
>>>> to receive input-mt updates for 2.6.38.
>>>>
>>>> The tree contains core changes as well as dependent changes to hid drivers. You
>>>> also find the new hid-egalax driver in there, signed off by Jiri.
>>>
>>> Pulled, thank you Henrik.
>>>
>>> I wonder if we should move input-mt.h into input/mt.h (and if someone
>>> would bother to input-polldev.h there that would be great too).
>>
>>
>> Sure, I have been wondering about that too. Right away, or later?
> 
> Better sooner than later as you'll have less places to patch ;)


No problem, will do.

>>
>>> Also I try to sync with mainline once per release, at -rc1, unless I
>>> know that my changes will conflict with some other work. I'd recommend
>>> you do the same so that when I pull from you I am getting just your
>>> changes and not the rest of stuff from mainline.
>>
>>
>> No problem - I will see what sync point you end up using, and I will rebase to
>> the same point.
> 
> No, not rebase, pull please. Public branches should not be rebased, at
> least not when they have been pulled from.


Understood. I was using the term "rebase" to loosely.

Thanks,
Henrik
