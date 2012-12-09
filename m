Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932873Ab2LIJyx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 04:54:53 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:40717 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932795Ab2LIJyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 04:54:50 -0500
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <CALCETrXOk74kcfqHBwuAZEY3rpZJFc65e0zZszu-34Qk+ui1dA@mail.gmail.com>
References: <CALCETrUZyD=Z6bQ3vZC8_9giv67-BuZGm2PgshM0E5hUDe6=bQ@mail.gmail.com>
 <1354929004.20497.4@driftwood> <CALCETrXOk74kcfqHBwuAZEY3rpZJFc65e0zZszu-34Qk+ui1dA@mail.gmail.com>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Sun, 9 Dec 2012 10:54:30 +0100
Message-ID: <CAKgNAkjkRVw8UqhK4eKZ1uxgT=SSiYqx-AYtGMz8v1pae=OiNA@mail.gmail.com>
Subject: Re: [PATCH] Document how capability bits work
To: Andy Lutomirski <luto@amacapital.net>
Cc: Rob Landley <rob@landley.net>, Serge Hallyn <serge.hallyn@canonical.com>,
        James Morris <james.l.morris@oracle.com>,
        linux-security-module@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>, linux-kernel@vger.kernel.org,
        Eric Paris <eparis@redhat.com>, "Andrew G. Morgan" <morgan@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy,

On Sat, Dec 8, 2012 at 2:27 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Fri, Dec 7, 2012 at 5:10 PM, Rob Landley <rob@landley.net> wrote:
>> On 12/07/2012 01:32:18 PM, Andy Lutomirski wrote:
>>>
>>> On Fri, Dec 7, 2012 at 11:21 AM, Serge Hallyn
>>> <serge.hallyn@canonical.com> wrote:
>>> > Quoting Andy Lutomirski (luto@amacapital.net):
>>> >> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
>>> >> ---
>>> >>  Documentation/security/capabilities.txt | 161
>>> >> ++++++++++++++++++++++++++++++++
>>> >>  1 file changed, 161 insertions(+)
>>> >>  create mode 100644 Documentation/security/capabilities.txt
>>> >
>>> > TBH, I think a pointer to the capabilities.7 man page would be better.
>>> > (plus, if you feel they are needed, updates to the man page)
>>>
>>> Updating capabilities.7 wouldn't be a bad idea, but IMO it certainly
>>> needs work.  For example, it says:
>>
>> ...
>>
>>> I would be happy to revise this patch to reference capabilities.7.
>>
>>
>> The capabilities.7 man page is existing maintained documentation on how to
>> use this from userspace, which seems to be the point of your document.
>> Having include/linux/uapi/capability.h mention its existence might be good.
>> Feeding fixes to the documentation we've already got would be good.
>>
>> I read your document having largely ignored capabilities for years, and
>> don't feel I have a better understanding of them after reading it. (I'm
>> aware they exist, I'm aware they're used as a justification for extended
>> attributes, I'm aware people think breaking a fireplace into a bunch of
>> candleflames increases fire safety. I'm aware of
>> http://forums.grsecurity.net/viewtopic.php?f=7&t=2522 and I _used_ to be
>> aware of
>> http://userweb.kernel.org/~morgan/sendmail-capabilities-war-story.html but
>> kernel.org never bothered putting most of itself back together after the
>> breakin last year and archive.org doesn't have a copy. I'm aware that a
>> decade ago at Atlanta Linux Showcase in california Ted Tso was sad nobody
>> was using them yet. But I haven't hugely been tracking changes over the last
>> 5 years in how they work. It looks like figuring out who has what involves
>> working through exercises in set theory that cannot be explained using a 127
>> bit ascii set. Personally, I prefer "more dangerous" security setups that
>> don't require I pull out scratch paper to reason about the state of the
>> system, so perhaps I'm biased here.)
>
> Heh.  I agree this stuff is shockingly complicated.  (And this
> document isn't wriiten in ASCII...)
>
> I actually wrote this file because I was reading the code and trying
> to figure out wtf was going on.  This is the result :)  I'll see if I
> can improve capabilities.7.
>
> Any pointers to things you wanted to understand?

Indeed, it strikes me that a patch to capabilities.7 would be best.
This is all about user-visible stuff, and hiding things in a kernel
source file is not very user visible.

capabilities.7 is a big page. It would be best to break the patch into
logically distinct pieces, if that can be sensibly done.

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
