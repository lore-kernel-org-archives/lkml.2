Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964818Ab2LFDER (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 22:04:17 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:43601 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754436Ab2LFDEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 22:04:15 -0500
MIME-Version: 1.0
In-Reply-To: <20121206011402.GB27172@dastard>
References: <1353366267-15629-1-git-send-email-david@fromorbit.com>
 <201212051148.28039.Martin@lichtvoll.de> <CA+55aFzgP29WfB1yvnj+Q9-TsbX+b-TCCjTS_vPJ16DxMy6aDQ@mail.gmail.com>
 <201212051718.44017.Martin@lichtvoll.de> <CA+55aFxsPBo4TZEPq+14NBE8Snmd9qiTjAiEP0fFXBzaJ9y+gw@mail.gmail.com>
 <20121206011402.GB27172@dastard>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 5 Dec 2012 19:03:52 -0800
X-Google-Sender-Auth: gnNYEc0azi-R9rcEEGqXiYNnltU
Message-ID: <CA+55aFzjOr1tw4UAdWazgvzOu6if8hOc4PqgLeX4Um_k-kuguw@mail.gmail.com>
Subject: Re: [PATCH, 3.7-rc7, RESEND] fs: revert commit bbdd6808 to fallocate UAPI
To: Dave Chinner <david@fromorbit.com>
Cc: Martin Steigerwald <Martin@lichtvoll.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 5, 2012 at 5:14 PM, Dave Chinner <david@fromorbit.com> wrote:
>
> And for changes to syscalls? That's something that must be peer
> reviewed because we are going to be stuck with those changes forever
> as we can't undo them at a later date. It doesn't matter who made the
> change in question, I would have done exactly the same thing....

The thing that people are complaining about is exactly the reverse of
this. It's *protecting* us from making mistakes, and doesn't actually
add any new interfaces in itself.

This is why I'm so annoyed with this stupid thread. It's been going on
forever, and reverting that change WOULD BE OBJECTIVELY A BAD IDEA.

The change is a one-liner, doesn't add any code at all, seeks to
protect us from potential future mistakes, and had a good technical
rationale for it. Seriously. Why are we even discussing this two weeks
later?

Don't even bother to answer that question. This thread isn't worth it.

              Linus
