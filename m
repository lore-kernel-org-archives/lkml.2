Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757369Ab1F2SGf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 14:06:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49318 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754409Ab1F2SGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 14:06:34 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTi=dQRi82gkDwtR3Kh2R7f0uGu7HpQ@mail.gmail.com>
References: <201106100355.p5A3t8Aa024924@drepperk.user.openhosting.com>
 <BANLkTin7wm6m5bN4CfQzhJZuhy3bUrS80A@mail.gmail.com> <4E0ADF27.5070805@akkadia.org>
 <BANLkTi=dQRi82gkDwtR3Kh2R7f0uGu7HpQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 29 Jun 2011 11:05:18 -0700
Message-ID: <BANLkTi=pUZnhBa9W0eobQ_RWQGtMZ3u6Eg@mail.gmail.com>
Subject: Re: [PATCH] Add cloexec information to fdinfo
To: Ulrich Drepper <drepper@akkadia.org>
Cc: akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
        linux-kernel@vger.kernel.org, rientjes@google.com,
        viro@zeniv.linux.org.uk, wilsons@start.ca
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 9:22 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> So at least O_CLOEXEC seems to have a real reason, and fits the
> existing model. I think a patch like the attached would be ok. Does
> that work for you? It's entirely untested here.

Ok, minimally tested now, it seems to work from the one trivial
test-case I wrote for it.

I'm not going to commit it, but if others think this is a reasonable
thing to do and remind me during the next merge window, we can do it
then.

                        Linus
