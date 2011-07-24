Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751860Ab1GXSnQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 14:43:16 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:34673 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646Ab1GXSnJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 14:43:09 -0400
MIME-Version: 1.0
In-Reply-To: <20110724083126.29166727@bike.lwn.net>
References: <CAPA4HGVYuZ3S+OxU9dXgPuqk1ERrYNshUe27M8QmN7c4+B7LAA@mail.gmail.com>
	<CAPA4HGUHLDDTtaJ28jXNtRFJ6005=ZsQJa10TpoQmV_QxhYVPA@mail.gmail.com>
	<20110724083126.29166727@bike.lwn.net>
Date: Sun, 24 Jul 2011 20:43:08 +0200
X-Google-Sender-Auth: VXrJpLipTlLdyS-4MKFnA2zjDY8
Message-ID: <CAPA4HGU6EW60w7O5N4qKRrbFa=t6VK3RuC-Apzxb7d4QQ-QU5w@mail.gmail.com>
Subject: Re: [PATCH 2/2] docs: update the development process document.
From: Luis de Bethencourt <luis@debethencourt.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
        linux-doc@vger.kernel.org, Greg Kroah-Hartman <greg@kroah.com>,
        Andres Salomon <dilinger@queued.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonathan :)

On Sun, Jul 24, 2011 at 4:31 PM, Jonathan Corbet <corbet@lwn.net> wrote:
> On Sun, 24 Jul 2011 12:18:09 +0200
> Luis de Bethencourt <luis@debethencourt.com> wrote:
>
>>     Here's a set of changes updating Documentation/development-process.
>>     I have update kernel releases.
>
> I'm not convinced that the kernel version examples need to be updated all
> that often - but I don't see that it hurts anything either.  One thing,
> though:

I understand, and when I sent the patch I was aware you could have
said you weren't interested.
Should've asked before spending time on it, but then, it wasn't that
much time either.

>
>> @@ -65,19 +66,18 @@ will get up to somewhere between -rc6 and -rc9
>> before the kernel is
>>  considered to be sufficiently stable and the final 2.6.x release is made.
>>  At that point the whole process starts over again.
>>
>> -As an example, here is how the 2.6.38 development cycle went (all dates in
>> +As an example, here is how the 2.6.39 development cycle went (all dates in
>>  2011):
>
> A more useful exercise would have been to update things for the post-2.6
> era; there will be no more "final 2.6.x" releases.  Would you be interested
> in cleaning up that kind of stuff?  Otherwise I guess I'll get to it
> eventually.
>

I can do this. I was reading the file to learn about it myself, so I
can change it once I learn.

> One other thing:
>
>> -for example, the 2.6.36 kernel's history looked like:
>> +for example, the 2.6.38 kernel's history looked like:
>>
>> -     October 10      2.6.36 stable release
>> -     November 22     2.6.36.1
>> -     December 9      2.6.36.2
>> -     January 7       2.6.36.3
>> -     February 17     2.6.36.4
>> +     March 14        2.6.38 stable release
>> +     March 23        2.6.38.1
>> +     March 27        2.6.38.2
>> +     April 14        2.6.38.3
>> +     April 21        2.6.38.4
>> +     May 2           2.6.38.5
>> +     May 9           2.6.38.6
>> +     May 21          2.6.38.7
>> +     June 3          2.6.38.8
>>
>>  2.6.36.4 was the final stable update for the 2.6.36 release.
>
> Here you took out the 2.6.34.x stable updates, but left that last sentence
> as a sort of dangling reference.  If we really need to pull this forward,
> let's do the whole job.
>

Yes, I did this because there hasn't been a final release for 2.6.38 yet.
I will remove this line and update the above mentioned.

> Thanks,
>
> jon
>

No problem, my pleasure :)
Luis
