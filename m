Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932938Ab1EXSzw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 14:55:52 -0400
Received: from mail.lang.hm ([64.81.33.126]:58155 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932722Ab1EXSzu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 14:55:50 -0400
Date: Tue, 24 May 2011 11:55:27 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Matthias Schniedermeyer <ms@citd.de>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org, DRI <dri-devel@lists.freedesktop.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>
Subject: Re: (Short?) merge window reminder
In-Reply-To: <20110524183405.GA14493@citd.de>
Message-ID: <alpine.DEB.2.02.1105241147150.23692@asgard.lang.hm>
References: <BANLkTi=PLuZhx1=rCfOtg=aOTuC1UbuPYg@mail.gmail.com> <20110523192056.GC23629@elte.hu> <BANLkTikdgM+kSvaEYuQkgCYJZELnvwfetg@mail.gmail.com> <20110524183405.GA14493@citd.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 May 2011, Matthias Schniedermeyer wrote:

> On 23.05.2011 13:33, Linus Torvalds wrote:
>> On Mon, May 23, 2011 at 12:20 PM, Ingo Molnar <mingo@elte.hu> wrote:
>>>
>>> I really hope there's also a voice that tells you to wait until .42 before
>>> cutting 3.0.0! :-)
>>
>> So I'm toying with 3.0 (and in that case, it really would be "3.0",
>> not "3.0.0" - the stable team would get the third digit rather than
>> the fourth one.
>
> What about strictly 3 part versions? Just add a .0.
>
> 3.0.0 - Release Kernel 3.0
> 3.0.1 - Stable 1
> 3.0.2 - Stable 2
> 3.1.0 - Release Kernel 3.1
> 3.1.1 - Stable 1
> ...
>
> Biggest problem is likely version phobics that get pimples when they see
> trailing zeros. ;-)

since there are always issues discovered with a new kernel is released 
(which is why the -stable kernels exist), being wary of .0 kernels is not 
neccessarily a bad thing.

I still think a date based approach would be the best.

since people are worried about not knowing when a final release will 
happen, base the date on when the merge window opened or closed (always 
known at the time of the first -rc kernel)

in the thread on lwn, people pointed out that the latest 2.6.32 kernel 
would still be a 2009.12.X which doesn't reflect the fact that it was 
released this month. My suggestion for that is to make the X be the number 
of months (or years.months if you don't like large month values) between 
the merge window and the release of the -stable release. This would lead 
to a small problem when there are multiple -stable releases in a month, 
but since that doesn't last very long I don't see a real problem with just 
incramenting the month into the future in those cases.

David Lang
