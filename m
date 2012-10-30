Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757897Ab2J3V6A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 17:58:00 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:32971 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934528Ab2J3V56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 17:57:58 -0400
MIME-Version: 1.0
In-Reply-To: <87sj97hs5e.fsf@rustcorp.com.au>
References: <1348179300-11653-1-git-send-email-keescook@chromium.org>
	<CAHO5Pa2fysDRS3sFSy785XBKApxydN0ONW5kAfVJNkrB+wOaBw@mail.gmail.com>
	<50749DE8.7010703@zytor.com>
	<CAKgNAkgLW+0aHwzoY6vxmeeK_K5w2RyhxW+jOaJDn274NVbajw@mail.gmail.com>
	<5074A0AB.8040207@zytor.com>
	<87d30o7iy6.fsf@rustcorp.com.au>
	<CAKgNAkh=99=x1=8Y=3odem-fXc9zEEbLvCc0WQku5Kyso4qHuQ@mail.gmail.com>
	<87ipa8o4mn.fsf@rustcorp.com.au>
	<CAKgNAkiVxUiqJ1pYNq3wW_yQxcyhqntUzcEWscFOhJ3GaVn1aQ@mail.gmail.com>
	<87sj97hs5e.fsf@rustcorp.com.au>
Date: Tue, 30 Oct 2012 14:57:57 -0700
X-Google-Sender-Auth: f6K5yusIeNev2HSGmpCzBonVtgg
Message-ID: <CAGXu5jKnok56CHY_YQn9df9MC64TQFexs7fNMmF-NU4Yd+aAig@mail.gmail.com>
Subject: Re: [PATCH 1/4] module: add syscall to load module from fd
From: Kees Cook <keescook@chromium.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: mtk.manpages@gmail.com, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        jonathon@jonmasters.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 12:39 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:
>>> FIX: add flags arg to sys_finit_module()
>>>
>>> Thanks to Michael Kerrisk for keeping us honest.
>>
>> w00t! Thanks, Rusty ;-).
>>
>> Acked-by: Michael Kerrisk <mtk.manpages@gmail.com>
>
> Here's the version I ended up with when I added two flags.
>
> Lucas, is this useful to you?
>
> BTW Michael: why aren't the syscall man pages in the kernel source?
>
> Thanks,
> Rusty.
>
> module: add flags arg to sys_finit_module()
>
> Thanks to Michael Kerrisk for keeping us honest.  These flags are actually
> useful for eliminating the only case where kmod has to mangle a module's
> internals: for overriding module versioning.
>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Rusty,

I haven't seen this land in your modules-next tree. I just wanted to
make sure it hadn't gotten lost. I'd like to do some kmod tests
against linux-next, but I've been waiting for this to appear.

I acked this before, but as long as I'm replying again:

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

-- 
Kees Cook
Chrome OS Security
