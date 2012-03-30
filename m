Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761522Ab2C3XQI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 19:16:08 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:44160 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1761361Ab2C3XQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 19:16:04 -0400
Message-ID: <4F763EAF.2070904@xenotime.net>
Date: Fri, 30 Mar 2012 16:15:59 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
Subject: Re: [PATCH 1/8] Documentation: remove 'mach' from dontdiff file
References: <4F76196A.9070709@xenotime.net> <CA+55aFz0WyVfJgO9GDM4ssUoWPRZfY0rs+97+P6fmYtc-jnDCw@mail.gmail.com>
In-Reply-To: <CA+55aFz0WyVfJgO9GDM4ssUoWPRZfY0rs+97+P6fmYtc-jnDCw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2012 03:39 PM, Linus Torvalds wrote:

> On Fri, Mar 30, 2012 at 1:36 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
>> From: H Hartley Sweeten <hartleys@visionengravers.com>
>>
>> Documentation: remove mach from dontdiff file
> 
> Grr.
> 
> Most of these patches have the same stupid problem: why the *hell* do
> you repeat the single-line top-level description in both the Subject
> line and the body of the email? It only results in stupid duplicate
> lines in the commit logs.
> 
> This is a disease. I don't know who the heck started doing it, but
> it's WRONG. It's stupid. What broken piece-of-shit tool is it that
> does this braindamage?
> 
> Fix it. Stop sending these broken commit messages to people.
> 
> I'm grumpy, yes, because this is a common problem. I see it all over
> the place, and it makes our commit logs look f*cking retarded.
> 
> If you absolutely need to repeat the subject line in the body of the
> email, do it together with the author line, and mark it as such, ie do
> this:
> 
>   From: H Hartley Sweeten <hartleys@visionengravers.com>
>   Subject: Documentation: remove mach from dontdiff file
> 
> so that git sees that it's a repeat of the subject line. Don't just
> put it in the body as another stupid repeat.


I see.  Thanks for the info.

Shall I resend all of these?

-- 
~Randy
