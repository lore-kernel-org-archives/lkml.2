Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966265Ab2JZTrR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 15:47:17 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:40302 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966243Ab2JZTrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 15:47:15 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFxSO9oGtNEBOAVXj+OQn0tye7rNBu8C5tsggsYdZarNrw@mail.gmail.com>
References: <20121026185021.GA1960@www.outflux.net>
	<CA+55aFxSO9oGtNEBOAVXj+OQn0tye7rNBu8C5tsggsYdZarNrw@mail.gmail.com>
Date: Fri, 26 Oct 2012 12:46:56 -0700
X-Google-Sender-Auth: Xk_4_XRpZdrS6EUMXTiOVvDmTmU
Message-ID: <CAGXu5jL4qh5nXBJJQAr-42hZHk7bP0Gn468Sf3i8+W0eo1_LKA@mail.gmail.com>
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

On Fri, Oct 26, 2012 at 12:21 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Oct 26, 2012 at 11:50 AM, Kees Cook <keescook@chromium.org> wrote:
>> There are situations where devices running without initrds may need
>> very early protection from link vulnerabilities
>
> I really don't see what this argument is all about.
>
> If you don't have initrd, you still have early bootup scripts etc.
>
> If your early bootup has security problems, you have security
> problems. It has nothing to do with initrd, or with restricted links,
> or anything else.

I think there's value in being able to enable these protections at
build-time so there's no need for a distro to have to ship extra
files/lines, spend time setting it, etc. This isn't like other
tunables, IMO.

> I also refuse to add these kinds of micro-management config options
> and ask any kind of normal person these kinds of "do you want this
> random crazy feature". A config option would need to be way more sane,
> not this kind of micro-management.

Would a single config item be acceptable? What would be an agreeable
way to enable this at build-time?

-Kees

-- 
Kees Cook
Chrome OS Security
