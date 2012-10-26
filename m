Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966447Ab2JZU1f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 16:27:35 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:38293 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966399Ab2JZU1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 16:27:34 -0400
MIME-Version: 1.0
In-Reply-To: <CAGXu5jKP5XxSkz48PsqbrpBZMU=wjsmq+HExZGKMOeHrB9PHrg@mail.gmail.com>
References: <20121026185021.GA1960@www.outflux.net> <CA+55aFxSO9oGtNEBOAVXj+OQn0tye7rNBu8C5tsggsYdZarNrw@mail.gmail.com>
 <CAGXu5jL4qh5nXBJJQAr-42hZHk7bP0Gn468Sf3i8+W0eo1_LKA@mail.gmail.com>
 <CA+55aFzw_p-WJyBBGc5UFDU8yN698REH+Vc1fk=CDeq4JG8AFA@mail.gmail.com> <CAGXu5jKP5XxSkz48PsqbrpBZMU=wjsmq+HExZGKMOeHrB9PHrg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 26 Oct 2012 13:27:12 -0700
X-Google-Sender-Auth: U_z5QYUwX8gJTXpYNQtbTkO1mEY
Message-ID: <CA+55aFywEzhrxV0wMPwT0SNEL4mjo72kqbgcsmqm7JYKRYTCYQ@mail.gmail.com>
Subject: Re: [PATCH] VFS: add config options to enable link restrictions
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 1:23 PM, Kees Cook <keescook@chromium.org> wrote:
>
> I'd like it to be the exception to turn it _off_, rather than the
> exception to turn it on.

Kees, you don't seem to understand.

Breaking applications is unacceptable. End of story. It's broken them.
Get over it.

Distributions can turn it on with a security app. They already have it
for selinux selection etc. That's where this makes sense. Then
sysadmins can set it once (maybe it can default on there, at least for
new installs), and be done with it.

Your "IT HAS TO BE DONE AT BOOT TIME, THE SKY IS FALLING, NOTHING ELSE
IS ACCEPTABLE!" ranting is a disease. Stop it.

                   Linus
