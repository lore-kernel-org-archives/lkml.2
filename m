Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279Ab1DEPdm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 11:33:42 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41897 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017Ab1DEPdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 11:33:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=AwVmawkj1sF+bblbImCPISxMT7QgoE40xWZaACrVZ7qVwx5K3JgPgpZIvqm7NwWofF
         oiHi2P1vQy8owMVa+67oKR1xG+9SwNnJ3LkBNGd6yfPe1Q9VB8q/BeBmeS47KEDSNWv8
         7MJNuKHcq2E1a2+Huk77JkbXK06w20FPk0pQI=
Message-ID: <4D9B3639.80205@vexillium.org>
Date: Tue, 05 Apr 2011 16:33:13 +0100
From: Unavowed <unavowed@vexillium.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110310 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: Add NOGET quirk for the CH Pro Throttle
References: <4d988b60.29c6ec0a.0716.ffffa4bf@mx.google.com> <alpine.LNX.2.00.1104041105250.28516@pobox.suse.cz> <4D999177.4010401@vexillium.org> <alpine.LNX.2.00.1104041340080.28516@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1104041340080.28516@pobox.suse.cz>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/11 12:41, Jiri Kosina wrote:
> On Mon, 4 Apr 2011, Unavowed wrote:
> 
>>>> The CH Pro Throttle needs the NOGET quirk flag to work, just like other CH
>>>> Products devices which already have the flag set.
>>>>
>>>> Signed-off-by: Unavowed <unavowed@vexillium.org>
>>>
>>> Hi,
>>>
>>> thanks a lot for the patch.
>>>
>>> Would it please be possible to have a real name to attribute for patch 
>>> authorship and Signed-off-by line?
>>
>> Hi,
>>
>> Thanks for such a quick response.
>>
>> I'm sorry, but I only ever write contributions under a pseudonym.  Is
>> this not acceptable, especially for such a trivial patch?
> 
> Well, see paragraph 12) of Documentation/SubmittingPatches. Especially the 
> part with "sorry, no pseudonyms or anonymous contributions".
> 
> Now, I agree that trivial USB ID addition such as this really is 
> a bit borderline ... 

If that's the case then I would like to report a bug.  The HID device:

068e:00f1 CH Products, Inc. Pro Throttle

doesn't work with Linux.  After plugging in the device, it is recognised
but pressing buttons or moving axes doesn't trigger any events.  Adding
an entry to the HID blacklist with the HID_QUIRK_NOGET flag fixes the
problem.

I, and probably other flight sim fans running Linux, would be very happy
if someone could fix write a patch fixing this.

And if I may comment on that "no pseudonyms" policy, I don't fully
understand the motivation behind it.  After all, there have been many
authors of copyrighted works who created them without revealing their
real name[1].  Is this something to please the lawyers of Linux's
corporate overlords?

Thanks,

Unavowed

[1] http://en.wikipedia.org/wiki/List_of_pseudonyms
