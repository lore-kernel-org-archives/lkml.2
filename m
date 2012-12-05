Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab2LESZk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 13:25:40 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:57831 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308Ab2LESZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 13:25:39 -0500
MIME-Version: 1.0
In-Reply-To: <201212051718.44017.Martin@lichtvoll.de>
References: <1353366267-15629-1-git-send-email-david@fromorbit.com>
 <201212051148.28039.Martin@lichtvoll.de> <CA+55aFzgP29WfB1yvnj+Q9-TsbX+b-TCCjTS_vPJ16DxMy6aDQ@mail.gmail.com>
 <201212051718.44017.Martin@lichtvoll.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 5 Dec 2012 10:25:17 -0800
X-Google-Sender-Auth: rzIPyjGK8ZO90N8QCpUrFXJjl2s
Message-ID: <CA+55aFxsPBo4TZEPq+14NBE8Snmd9qiTjAiEP0fFXBzaJ9y+gw@mail.gmail.com>
Subject: Re: [PATCH, 3.7-rc7, RESEND] fs: revert commit bbdd6808 to fallocate UAPI
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 5, 2012 at 8:18 AM, Martin Steigerwald <Martin@lichtvoll.de> wrote:
>
> Did you actually *read* the thread, Linus?

I did. And I actually understood it. Unlike some people.

> Dave provided technical reasons.
>
> First in the patch description and then in:
>
> https://lkml.org/lkml/2012/11/26/700

No. That technical argument is an argument *against* changing the
current "specific bit meaning" reservation into a "generic fs private
use" bit.

The current one actually has a specific meaning (documented in the
name, if very little else), and is *not* some kind of "generic fs
private use" bit.  So the email you quote was actually an argument
against changing the current status quo.

And there is an actual technical reason for the current situation,
described in the original commit. Now, people may not *like* the fact
that the bit is commonly used out-of-tree (and used that way, rather
than with an ioctl), but it's a fact.  And quite frankly, ioctl's
aren't any better. They are just another different way of messing
things up.

Everything else in that thread has basically been whining about "I
don't like the current reality".

Yes, people can argue that "process" is about technical issues too,
but let's be honest: our process is fluid. Not everything gets
reviewed on the mailing list, and people *do* talk about things
face-to-face at conferences. And none of that changes the current
actual situation.

                 Linus
