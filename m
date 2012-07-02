Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932396Ab2GBSYm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 14:24:42 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:34370 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861Ab2GBSYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 14:24:41 -0400
MIME-Version: 1.0
In-Reply-To: <2779342.rcjlfQh1rr@vlad>
References: <2325453.OX7ktP55U1@vlad> <6810708.ZQq4lbXqoi@vlad>
 <CAK-9PRCb1jJdejvim48LP7GN6jHKDdkKVx-UY1Gpsbx1ROyQvQ@mail.gmail.com> <2779342.rcjlfQh1rr@vlad>
From: Chinmay V S <cvs268@gmail.com>
Date: Mon, 2 Jul 2012 23:54:09 +0530
Message-ID: <CAK-9PRBi3XOVtW3gs3doO=ecD0XWfNffVefdRCC1sGnLdT_9LA@mail.gmail.com>
Subject: Re: [PATCH RESEND] fs: Move bh_cachep to the __read_mostly section
To: Vlad Zolotarov <vlad@scalemp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shai@scalemp.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vlad,

I suppose we both are looking at opposite sides of the same coin.
While i am wary of the potential pitfalls,
you have focused on the benefits of using __read_mostly.

At this point i would like to send out a shout to everyone concerned to please
clarify the status of __read_mostly:

1. Is it being actively pursued? (systems that *will* clearly benefit from it)
2. Any actual results on real world use-cases? (w/ & w/o __read_mostly)
3. Is __read_mostly being accepted in non-architecture specific kernel code?
4. Is anyone working on a potential replacement for it?

regards
ChinmayVS


>I think your point is clear and has actually been nicely stated at
>thecodeartist.blogspot.com/2011/12/why-readmostly-does-not-work-as-it.htm
>(by u? :))

PS: Yes, the link i referred to *is* indeed my own article that i posted a few
months ago after my experiments with __read_mostly. I was initially excited when
i found this bit while digging through the code. But upon seeing that an entire
arch had disabled it, and then understanding why, i feel its usage needs to be
restricted to arch specific code and even then thoroughly tested too.
(then again, i may be wrong.)
