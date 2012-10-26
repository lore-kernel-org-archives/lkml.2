Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965125Ab2JZVlk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 17:41:40 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:38514 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933967Ab2JZVli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 17:41:38 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFywEzhrxV0wMPwT0SNEL4mjo72kqbgcsmqm7JYKRYTCYQ@mail.gmail.com>
References: <20121026185021.GA1960@www.outflux.net>
	<CA+55aFxSO9oGtNEBOAVXj+OQn0tye7rNBu8C5tsggsYdZarNrw@mail.gmail.com>
	<CAGXu5jL4qh5nXBJJQAr-42hZHk7bP0Gn468Sf3i8+W0eo1_LKA@mail.gmail.com>
	<CA+55aFzw_p-WJyBBGc5UFDU8yN698REH+Vc1fk=CDeq4JG8AFA@mail.gmail.com>
	<CAGXu5jKP5XxSkz48PsqbrpBZMU=wjsmq+HExZGKMOeHrB9PHrg@mail.gmail.com>
	<CA+55aFywEzhrxV0wMPwT0SNEL4mjo72kqbgcsmqm7JYKRYTCYQ@mail.gmail.com>
Date: Fri, 26 Oct 2012 14:41:37 -0700
X-Google-Sender-Auth: 3p9P17df9c9XCdZe0uMak_1Mbh4
Message-ID: <CAGXu5jK4-=c96YgrNJ+SLYZdqpG5WtR4WkfrSdwOwqt2pm5dFw@mail.gmail.com>
Subject: Re: [PATCH] VFS: add config options to enable link restrictions
From: Kees Cook <keescook@chromium.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 1:27 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Oct 26, 2012 at 1:23 PM, Kees Cook <keescook@chromium.org> wrote:
>>
>> I'd like it to be the exception to turn it _off_, rather than the
>> exception to turn it on.
>
> Kees, you don't seem to understand.
>
> Breaking applications is unacceptable. End of story. It's broken them.
> Get over it.

No, I get that. I've been over it. I can handle it being off by
default. I just want there to be a way to make it enabled at build
time. I'll explore some other options; it's sensible to tie it to
other settings/things that are security-sensitive.

-Kees

-- 
Kees Cook
Chrome OS Security
