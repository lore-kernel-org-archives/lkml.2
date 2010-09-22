Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751767Ab0IVGIj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 02:08:39 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46315 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab0IVGIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 02:08:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Ra62FULsz69ACFEs11SqFLloOP/gAu3R/nNUOeECCN3ZPA5YpQNqi9XX6S/no2I8zC
         UKZkMfMZHGX9CfKVmkOZTVLyqyvduD6oZj/le2BRxY6ukWjVBGtaO27SyzU7tgYKa4uz
         LiNi2Xei72WQjtwMkeG6eous22gtcHBqldLkw=
Message-ID: <4C999D6C.9090801@gmail.com>
Date: Tue, 21 Sep 2010 23:08:44 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:2.0b5pre) Gecko/20100827 Thunderbird/3.2a1pre
MIME-Version: 1.0
To: Finn Thain <fthain@telegraphics.com.au>
CC: Matt Turner <mattst88@gmail.com>, trivial@kernel.org,
        linux-kernel@vger.kernel.org,
        "Maciej W. Rozycki" <macro@linux-mips.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Dimitry Torokhov <dmitry.torokhov@gmail.com>,
        Ben Pfaff <blp@cs.stanford.edu>, Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH]Update-broken-web-addresses-in-the-kernel
References: <1285042724-19135-1-git-send-email-justinmattock@gmail.com> <AANLkTinE73z9QV0zriVE3bRtzMifWSGvG36hfvnA9biD@mail.gmail.com> <4C983C7D.1050000@gmail.com> <AANLkTimYp6ua743x9ze4fcU09ZZ=oZZd_iKCmU0WQ2h7@mail.gmail.com> <alpine.LNX.2.00.1009211516180.9370@nippy.intranet> <4C98D8AA.80606@gmail.com> <alpine.LNX.2.00.1009221205330.4570@nippy.intranet> <4C99740E.307@gmail.com> <alpine.LNX.2.00.1009221520560.7689@nippy.intranet>
In-Reply-To: <alpine.LNX.2.00.1009221520560.7689@nippy.intranet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2010 10:44 PM, Finn Thain wrote:
>
> On Tue, 21 Sep 2010, Justin P. Mattock wrote:
>
>> On 09/21/2010 07:41 PM, Finn Thain wrote:
>>>
>>> On Tue, 21 Sep 2010, Justin P. Mattock wrote:
>>>
>>>> On 09/20/2010 10:17 PM, Finn Thain wrote:
>>>>>
>>>>> I would say that if a URL is in the web archive, then no patch is
>>>>> needed.
> [snip]
>>> Applying your reasoning that "people are still wanting to read the old
>>> info", a policy to accept patches like:
>>> - http://foo/bar
>>> + http://web.archive.org/web/*/foo/bar
>>> would imply another continual stream of patches when the domain foo
>>> changes hands. Then you have to pach,
>>> - http://web.archive.org/web/*/foo/bar
>>> + http://web.archive.org/web/YYYYMMDDHHMMSS/foo/bar
>>>
>>> Then the problem becomes what is the correct YYYYMMMDDHHMMSS? The one
>>> closest to the datestamp of submission of the patch? Or the datestamp
>>> from the email that submitted the patch? When these questions arise,
>>> it becomes a new burden on maintainers to determine the right version
>>> of the web page in the archive, and whether or not the latest version
>>> is the best one.
>>>
>>
>> just was looking for apmv1.1.doc my search results are not so
>> good(everything is pointing to v2) but it is tricky to decipher..
>>
>>> So both of these (arguably) continuous streams of patches would become
>>> a burden on maintainers and offer little or no benefit to those
>>> reading the source code.
>>>
>>
>> true.. I see it as accommodating.. but then again maybe a museum if you
>> want to search about the first commador64 as opposed to ps3/xbox(I know
>> bad analogy, but only thing I can think of).
>>
>>> The benefit to end users is also dubious, because you're chasing web
>>> pages that were abandoned, implying low value in the first place.
>>>
>>
>> but at the time that was hot off the press info..(which I need to
>> respect, and should be taken care of).
>
> I think the best solution might be to somehow ensure that, in future, new
> links inserted into the kernel are qualified with a date stamp. E.g.
>
>    For technical information about the SUX-5000, please see:
>    <http://foo/bar>  (retrieved 1990/6/22)
>
> In this way, rather than adding loads of "www.webarchive.org" boilerplate
> without solving the problem, we can push the extra workload back to the
> patch authors instead of letting it fall to maintainers.
>
> If you know perl, you might be able to achieve this with
> scripts/checkpatch.pl.
>
> Finn
>

well, right now im just trying to get through all of these(in the most 
organized way..) but that does sound like a good idea, unfortunately
my perl skills are as far as knowing it's a binary that knows to take a 
bunch of commands(as for building anything to use it not yet..(maybe in 
the future)).

Justin P. Mattock
