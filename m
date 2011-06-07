Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932508Ab1FGVkf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 17:40:35 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:33470 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753472Ab1FGVkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 17:40:33 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Jun 2011 17:40:33 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Message-ID:In-Reply-To:References:Date:Subject:From:To:Cc:User-Agent:MIME-Version:Content-Type:Content-Transfer-Encoding:X-Priority:Importance:X-Identified-User;
	b=nPT4hJKvs9zrz6Im3uVz0UUvGqxUwrsRiv/QB430ugJKYM9u249p+da5hHykDqIEB0LszibDzrQTdlSs+Y0amRQ3bkf3RFqpXAkz9mMWArpHl3wPno2nJ3THezcLnspY;
Message-ID: <05cba294449b86a9aa22cec4abc7e98f.squirrel@xenotime.net>
In-Reply-To: <4DEE9695.7060805@ece.ntua.gr>
References: <4DEDD5F4.1070602@kingswood-consulting.co.uk>
    <1307451186.4204.953.camel@calx> <4DEE808D.6020405@ece.ntua.gr>
    <1307477435.4204.968.camel@calx> <4DEE8AD9.3050508@ece.ntua.gr>
    <1307479572.4204.977.camel@calx>
    <alpine.DEB.2.02.1106071349000.28905@asgard.lang.hm>
    <1307480372.4204.987.camel@calx> <4DEE9695.7060805@ece.ntua.gr>
Date: Tue, 7 Jun 2011 14:33:53 -0700
Subject: Re: ketchup script and 3.0
From: "Randy Dunlap" <rdunlap@xenotime.net>
To: "Stratos Psomadakis" <psomas@ece.ntua.gr>
Cc: "Matt Mackall" <mpm@selenic.com>, david@lang.hm,
        linux-kernel@vger.kernel.org,
        "Frank Kingswood" <frank@kingswood-consulting.co.uk>,
        "Linus Torvalds" <torvalds@linux-foundation.org>
User-Agent: SquirrelMail/1.4.21
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:program running on server}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, June 7, 2011 2:22 pm, Stratos Psomadakis wrote:
> On 06/07/2011 11:59 PM, Matt Mackall wrote:
>> On Tue, 2011-06-07 at 13:50 -0700, david@lang.hm wrote:
>>> On Tue, 7 Jun 2011, Matt Mackall wrote:
>>>
>>>> But my point is that if we have adhoc transitions, we will encounter
>>>> the
>>>> "fix all the scripts and websites" pain at every transition. And tools
>>>> that are managed via distros and the like can literally take years to
>>>> get into the hands of users. It'd be nice if the copy of ketchup
>>>> shipped
>>>> in <enterprise distro> just worked 3 years from now because 4.0 wasn't
>>>> a
>>>> surprise.
>>> if you special case 2.4->2.6, and make the default that 4.0 > 3.x, 5.0
>>> >
>>> 4.x, etc won't things 'just work' for the forseeable future?
>> No, because you sometimes want to know what 2.6.39++ is and what 3.0--
>> is.
>>
>> For instance, to upgrade from 2.6.37.2 to 3.1.2, ketchup will want to
>> download, cache, and apply:
>>
>> patch-2.6.37.2 (reversed!)
>> patch-2.6.38
>> patch-2.6.39
>> patch-3.0 ?? <- hopefully Linus will make a delta against 2.6.39!
>> patch-3.1
>> patch-3.1.2
> Well, if this is a ketchup-only issue (and there's no other need for
> defining at which point major numbers are going to inc), we could find a
> solution/workaround (to future-proof it, without the need of constant
> updating of the code with every major release), but it'll probably be
> uglier, and I think that what Matt proposed is better.

It's also an issue for scripts/patch-kernel, unless I decide
to just kill (drop) it.

> Anyway, when this issue is clarified, I'll try to fix the code, in order
> to handle next major releases, without requiring code changes.



-- 
~Randy

