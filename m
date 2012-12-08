Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757545Ab2LHB1t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 20:27:49 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:64583 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757500Ab2LHB1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 20:27:46 -0500
MIME-Version: 1.0
In-Reply-To: <1354929004.20497.4@driftwood>
References: <CALCETrUZyD=Z6bQ3vZC8_9giv67-BuZGm2PgshM0E5hUDe6=bQ@mail.gmail.com>
 <1354929004.20497.4@driftwood>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 7 Dec 2012 17:27:25 -0800
Message-ID: <CALCETrXOk74kcfqHBwuAZEY3rpZJFc65e0zZszu-34Qk+ui1dA@mail.gmail.com>
Subject: Re: [PATCH] Document how capability bits work
To: Rob Landley <rob@landley.net>
Cc: Serge Hallyn <serge.hallyn@canonical.com>,
        James Morris <james.l.morris@oracle.com>,
        linux-security-module@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>, linux-kernel@vger.kernel.org,
        Eric Paris <eparis@redhat.com>, "Andrew G. Morgan" <morgan@kernel.org>,
        mtk.manpages@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 7, 2012 at 5:10 PM, Rob Landley <rob@landley.net> wrote:
> On 12/07/2012 01:32:18 PM, Andy Lutomirski wrote:
>>
>> On Fri, Dec 7, 2012 at 11:21 AM, Serge Hallyn
>> <serge.hallyn@canonical.com> wrote:
>> > Quoting Andy Lutomirski (luto@amacapital.net):
>> >> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
>> >> ---
>> >>  Documentation/security/capabilities.txt | 161
>> >> ++++++++++++++++++++++++++++++++
>> >>  1 file changed, 161 insertions(+)
>> >>  create mode 100644 Documentation/security/capabilities.txt
>> >
>> > TBH, I think a pointer to the capabilities.7 man page would be better.
>> > (plus, if you feel they are needed, updates to the man page)
>>
>> Updating capabilities.7 wouldn't be a bad idea, but IMO it certainly
>> needs work.  For example, it says:
>
> ...
>
>> I would be happy to revise this patch to reference capabilities.7.
>
>
> The capabilities.7 man page is existing maintained documentation on how to
> use this from userspace, which seems to be the point of your document.
> Having include/linux/uapi/capability.h mention its existence might be good.
> Feeding fixes to the documentation we've already got would be good.
>
> I read your document having largely ignored capabilities for years, and
> don't feel I have a better understanding of them after reading it. (I'm
> aware they exist, I'm aware they're used as a justification for extended
> attributes, I'm aware people think breaking a fireplace into a bunch of
> candleflames increases fire safety. I'm aware of
> http://forums.grsecurity.net/viewtopic.php?f=7&t=2522 and I _used_ to be
> aware of
> http://userweb.kernel.org/~morgan/sendmail-capabilities-war-story.html but
> kernel.org never bothered putting most of itself back together after the
> breakin last year and archive.org doesn't have a copy. I'm aware that a
> decade ago at Atlanta Linux Showcase in california Ted Tso was sad nobody
> was using them yet. But I haven't hugely been tracking changes over the last
> 5 years in how they work. It looks like figuring out who has what involves
> working through exercises in set theory that cannot be explained using a 127
> bit ascii set. Personally, I prefer "more dangerous" security setups that
> don't require I pull out scratch paper to reason about the state of the
> system, so perhaps I'm biased here.)

Heh.  I agree this stuff is shockingly complicated.  (And this
document isn't wriiten in ASCII...)

I actually wrote this file because I was reading the code and trying
to figure out wtf was going on.  This is the result :)  I'll see if I
can improve capabilities.7.

Any pointers to things you wanted to understand?

--Andy
