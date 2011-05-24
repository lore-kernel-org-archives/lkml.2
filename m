Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757594Ab1EXVZV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 17:25:21 -0400
Received: from DMZ-MAILSEC-SCANNER-3.MIT.EDU ([18.9.25.14]:63415 "EHLO
	dmz-mailsec-scanner-3.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756931Ab1EXVZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 17:25:20 -0400
X-AuditID: 1209190e-b7c39ae000000a8c-15-4ddc2239ed4f
Message-ID: <4DDC2236.6010608@mit.edu>
Date: Tue, 24 May 2011 17:25:10 -0400
From: Andy Lutomirski <luto@MIT.EDU>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org, DRI <dri-devel@lists.freedesktop.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>
Subject: Re: (Short?) merge window reminder
References: <BANLkTi=PLuZhx1=rCfOtg=aOTuC1UbuPYg@mail.gmail.com> <20110523192056.GC23629@elte.hu> <BANLkTikdgM+kSvaEYuQkgCYJZELnvwfetg@mail.gmail.com>
In-Reply-To: <BANLkTikdgM+kSvaEYuQkgCYJZELnvwfetg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFKsWRmVeSWpSXmKPExsUixCmqrGuldMfX4M9mFos569ewWVz5+p7N
	4s/PTawWHbu+sljs2XuSxeLyrjlsFvfW/Ge12HKpmdXiUd9bdgdOj1ttf5g9Nn2axO5xYsZv
	Fo/73ceZPDafrvb4vEkugC2KyyYlNSezLLVI3y6BK+P1nEvsBfN5K14sWcPcwLiFq4uRk0NC
	wETixLnDTBC2mMSFe+vZuhi5OIQE9jFKLJ55ggnC2cAo8ePxU6jMBSaJQxMus4C08AqoSXzb
	eZERxGYRUJVYtecOG4jNJqAi0bH0AdhYUYFKiXdrtrBD1AtKnJz5BKxXRMBI4vOLK6wgQ5kF
	7jBJ3DlxESwhLKAtcWbSGajV0xgl/rROYAZJcAo4Sly40wTUwQHUYS3xbXcRSJhZQF5i+9s5
	zBMYBWch2TELoWoWkqoFjMyrGGVTcqt0cxMzc4pTk3WLkxPz8lKLdI31cjNL9FJTSjcxgqNF
	km8H49eDSocYBTgYlXh411++7SvEmlhWXJl7iFGSg0lJlHej4h1fIb6k/JTKjMTijPii0pzU
	4kOMEhzMSiK8DRJAOd6UxMqq1KJ8mJQ0B4uSOO9MSXVfIYH0xJLU7NTUgtQimKwMB4eSBO82
	kKGCRanpqRVpmTklCGkmDk6Q4TxAw3eC1PAWFyTmFmemQ+RPMepydD74cYBRiCUvPy9VSpz3
	MEiRAEhRRmke3BxYknvFKA70ljDvK5AqHmCChJv0CmgJE9ASib83QZaUJCKkpBoYNX94c/A/
	Xve9b3Huv77ejCsTnh7ZKll8W3pp5tQP9yMFclgnNi+svasRVfJ80YcbjVsff7Zpul9a+7ax
	V86MtdLlk6PczGl22Qo1XDvV0yPbZhxfG5e+eCGftdv7aeeTNzjdmKWbdOzACx39T1bCmwPm
	7Xz/ry39AYco+/nouy737O498TqQp8RSnJFoqMVcVJwIAPE5nfZNAwAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2011 04:33 PM, Linus Torvalds wrote:
> On Mon, May 23, 2011 at 12:20 PM, Ingo Molnar<mingo@elte.hu>  wrote:
>>
>> I really hope there's also a voice that tells you to wait until .42 before
>> cutting 3.0.0! :-)
>
> So I'm toying with 3.0 (and in that case, it really would be "3.0",
> not "3.0.0" - the stable team would get the third digit rather than
> the fourth one.
>
> But no, it wouldn't be for 42. Despite THHGTTG, I think "40" is a
> fairly nice round number.
>
> There's also the timing issue - since we no longer do version numbers
> based on features, but based on time, just saying "we're about to
> start the third decade" works as well as any other excuse.
>

I don't think year-based versions (like 2011.0 for the first 2011 
release, or maybe 2011.5 for May 2011) are pretty, but I'll make an 
argument for them anyway: it makes it easier to figure out when hardware 
ought to be supported.

So if I buy a 2014-model laptop and the coffee-making button doesn't 
work, and my favorite distro is running the 2013 kernel, then I know I 
shouldn't expect to it to work.  (Graphics drivers are probably a more 
realistic example.)

Also, when someone in my lab installs <insert ancient enterprise distro 
here> on a box that's running software I wrote that needs to support 
modern high-speed peripherals, then I can say "What?  You seriously 
expect this stuff to work on Linux 2007?  Let's install a slightly less 
stable distro from at least 2010."  This sounds a lot less nerdy than 
"What?  You seriously expect this stuff to work on Linux 2.6.27?  Let's 
install a slightly less stable distro that uses at least 2.6.36."


--Andy
