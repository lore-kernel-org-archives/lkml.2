Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751612Ab0IVDMM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 23:12:12 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43745 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab0IVDML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 23:12:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=HFkPpq5lIY2qtIq/amo9YeDCrdyndrnJK4IKCLpT7jGwdIy90Ah/rn1yU+m2dgqmxb
         dLESMDakmQ1UFQUbNeBjBOuhehQu76OgAYxOydRcDA9t4Poy4u63ePDGGMnJ8GPNmxER
         Wl9FehBs8GDo02BIMIF9Fep3J6GInwBT3QjIM=
Message-ID: <4C99740E.307@gmail.com>
Date: Tue, 21 Sep 2010 20:12:14 -0700
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
References: <1285042724-19135-1-git-send-email-justinmattock@gmail.com> <AANLkTinE73z9QV0zriVE3bRtzMifWSGvG36hfvnA9biD@mail.gmail.com> <4C983C7D.1050000@gmail.com> <AANLkTimYp6ua743x9ze4fcU09ZZ=oZZd_iKCmU0WQ2h7@mail.gmail.com> <alpine.LNX.2.00.1009211516180.9370@nippy.intranet> <4C98D8AA.80606@gmail.com> <alpine.LNX.2.00.1009221205330.4570@nippy.intranet>
In-Reply-To: <alpine.LNX.2.00.1009221205330.4570@nippy.intranet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2010 07:41 PM, Finn Thain wrote:
>
> On Tue, 21 Sep 2010, Justin P. Mattock wrote:
>
>> On 09/20/2010 10:17 PM, Finn Thain wrote:
>>>
>>> I would say that if a URL is in the web archive, then no patch is needed.
>>>
>>> Finn
>>>
>>
>> before I go and remove all of the archive.org stuff, can I get some feedback
>> from other people as well on having this used? i.e. if keeping the old broken
>> link in the kernel, how will people know to go to archive.org or any other
>> archive site to read the old info?, as opposed to already having this in there
>> so people can just click and go?..
>>
>> The idea to use archive.org came from this thread:
>> http://amailbox.org/mailarchive/linux-kernel/2010/7/21/4596207/thread
>> where there are people still wanting to read the old info.
>
> If people want to read the old links, and they don't know about
> archive.org, then they should. If you've seen one
> "http://web.archive.org/web/*/foo/bar", you've seen them all. So this is
> bloat in some sense.
>

I dont like this.. reason for just ripping them out from the first 
series back in july/august(but to accommodate peoples needs I added this).

> As the web matures, and more and more information disappears from the web,
> archive.org will become common knowledge (if it isn't already).
>

I had never heard of it.. but nor do I ever really search for some 
technology back in the 90's(but then again I suppose I do from time to 
time).

> Applying your reasoning that "people are still wanting to read the old
> info", a policy to accept patches like:
> - http://foo/bar
> + http://web.archive.org/web/*/foo/bar
> would imply another continual stream of patches when the domain foo
> changes hands. Then you have to pach,
> - http://web.archive.org/web/*/foo/bar
> + http://web.archive.org/web/YYYYMMDDHHMMSS/foo/bar
>
> Then the problem becomes what is the correct YYYYMMMDDHHMMSS? The one
> closest to the datestamp of submission of the patch? Or the datestamp from
> the email that submitted the patch? When these questions arise, it becomes
> a new burden on maintainers to determine the right version of the web page
> in the archive, and whether or not the latest version is the best one.
>

just was looking for apmv1.1.doc my search results are not so 
good(everything is pointing to v2) but it is tricky to decipher..

> So both of these (arguably) continuous streams of patches would become a
> burden on maintainers and offer little or no benefit to those reading the
> source code.
>

true.. I see it as accommodating.. but then again maybe a museum if you 
want to search about the first commador64 as opposed to ps3/xbox(I know 
bad analogy, but only thing I can think of).

> The benefit to end users is also dubious, because you're chasing web pages
> that were abandoned, implying low value in the first place.
>

but at the time that was hot off the press info..(which I need to 
respect, and should be taken care of).

> Though they move from one URL to another, the links that are valuable are
> the web pages that are regularly updated. These are are the links that
> need to be kept up-to-date. And I think your work in that direction is
> valuable.
>
> Thanks.
>
> Finn
>


one thing that gets me.. is, is the maintainer/author/company of their 
_old project_, (even if it's a link)can be that irresponsible to abandon 
their child like that? atleast have the responsibility to update the 
kernel, or have one of the hyperlink forward things etc..(the leave it, 
im on to bigger better things I don't need this anymore _misfit_ eeks 
me, but we all are guilty of this one way or another..) keep in mind 
that's just my 00.02$

Thanks for the help as well my friend.. FWIW I went through the arch 
stuff and resent, ended putting the archive.org links on a separate 
patch to make things easier..(and in the meanwhile I'm going through the 
rest...(but might crap out..and end up having a beer..(we will see though)).

Justin P. Mattock
