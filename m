Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935376Ab2C3WkP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:40:15 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:41247 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935279Ab2C3WkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 18:40:07 -0400
MIME-Version: 1.0
In-Reply-To: <4F76196A.9070709@xenotime.net>
References: <4F76196A.9070709@xenotime.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 30 Mar 2012 15:39:45 -0700
X-Google-Sender-Auth: QBkgkWRmYxkOZQerxAgV-t4VxvA
Message-ID: <CA+55aFz0WyVfJgO9GDM4ssUoWPRZfY0rs+97+P6fmYtc-jnDCw@mail.gmail.com>
Subject: Re: [PATCH 1/8] Documentation: remove 'mach' from dontdiff file
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2012 at 1:36 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> From: H Hartley Sweeten <hartleys@visionengravers.com>
>
> Documentation: remove mach from dontdiff file

Grr.

Most of these patches have the same stupid problem: why the *hell* do
you repeat the single-line top-level description in both the Subject
line and the body of the email? It only results in stupid duplicate
lines in the commit logs.

This is a disease. I don't know who the heck started doing it, but
it's WRONG. It's stupid. What broken piece-of-shit tool is it that
does this braindamage?

Fix it. Stop sending these broken commit messages to people.

I'm grumpy, yes, because this is a common problem. I see it all over
the place, and it makes our commit logs look f*cking retarded.

If you absolutely need to repeat the subject line in the body of the
email, do it together with the author line, and mark it as such, ie do
this:

  From: H Hartley Sweeten <hartleys@visionengravers.com>
  Subject: Documentation: remove mach from dontdiff file

so that git sees that it's a repeat of the subject line. Don't just
put it in the body as another stupid repeat.

                                  Linus
