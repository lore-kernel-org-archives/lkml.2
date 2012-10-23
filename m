Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778Ab2JWHid (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 03:38:33 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:35289 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450Ab2JWHib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 03:38:31 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <87sj97hs5e.fsf@rustcorp.com.au>
References: <1348179300-11653-1-git-send-email-keescook@chromium.org>
 <CAHO5Pa2fysDRS3sFSy785XBKApxydN0ONW5kAfVJNkrB+wOaBw@mail.gmail.com>
 <50749DE8.7010703@zytor.com> <CAKgNAkgLW+0aHwzoY6vxmeeK_K5w2RyhxW+jOaJDn274NVbajw@mail.gmail.com>
 <5074A0AB.8040207@zytor.com> <87d30o7iy6.fsf@rustcorp.com.au>
 <CAKgNAkh=99=x1=8Y=3odem-fXc9zEEbLvCc0WQku5Kyso4qHuQ@mail.gmail.com>
 <87ipa8o4mn.fsf@rustcorp.com.au> <CAKgNAkiVxUiqJ1pYNq3wW_yQxcyhqntUzcEWscFOhJ3GaVn1aQ@mail.gmail.com>
 <87sj97hs5e.fsf@rustcorp.com.au>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Tue, 23 Oct 2012 09:38:11 +0200
Message-ID: <CAKgNAkim+mz3Gqs79AqeV9NAXzS9Ve+RN4hZc1+RRm8PCv9BLw@mail.gmail.com>
Subject: Re: [PATCH 1/4] module: add syscall to load module from fd
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        jonathon@jonmasters.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 9:39 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
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

So, this more or less reached the status of an FAQ, and here are my thoughts:
http://www.kernel.org/doc/man-pages/todo.html#migrate_to_kernel_source

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
