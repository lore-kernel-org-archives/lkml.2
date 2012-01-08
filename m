Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609Ab2AHV0f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 16:26:35 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55784 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528Ab2AHV0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 16:26:34 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1201082028140.24030@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1201082028140.24030@swampdragon.chaosbits.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 8 Jan 2012 13:26:12 -0800
X-Google-Sender-Auth: eJm6LmgAh9f-7iA5QHc3cGh9_mo
Message-ID: <CA+55aFwO9Wtq=NEpMskW-2wrWZAGh-C6VBXENA3LtFOk=tUwgQ@mail.gmail.com>
Subject: Re: Please merge two small bug fix patches from linux-next
To: Jesper Juhl <jj@chaosbits.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 8, 2012 at 11:51 AM, Jesper Juhl <jj@chaosbits.net> wrote:
>
> Below are two patches that have been in linux-next for ages (via akpm's
> tree). They are prette simple, straight-up, bug fixes. They have been
> submitted to maintainers multiple times over (IIRC at least the past
> year), but for some reason the maintainers seem uninterested in picking
> them up (or even responding to them).
> There has been no negative comments at all to them while they have been in
> -next.
> I'd really appreciate it if they could get merged.
>
> I've just pulled them out of the current linux-next and applied them on
> top of your tree - that's what is below.

So where are they? Git tree or what?

And if you want me to apply them as patches, please send them as
proper individual patches instead of askng me to "merge" them.

And they seem to have Andrew's sign-off, so I'd have expected them to
come through Andew. What's up?

                      Linus
