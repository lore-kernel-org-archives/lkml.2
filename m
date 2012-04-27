Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760692Ab2D0SnW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 14:43:22 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:34978 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757288Ab2D0SnU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 14:43:20 -0400
MIME-Version: 1.0
In-Reply-To: <20120427.143402.1028957981042061092.davem@davemloft.net>
References: <CA+55aFxEP7-+N7vTPZ-4hD-UirZ=+YMJh2x3EjZvUmjjyOchtg@mail.gmail.com>
 <4F9A6ABA.6050503@msgid.tls.msk.ru> <CA+55aFwud1nXRr+HpzH8rSkEWcZ_rJmoE7UtQt76D=A3qcb6GQ@mail.gmail.com>
 <20120427.143402.1028957981042061092.davem@davemloft.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 27 Apr 2012 11:42:58 -0700
X-Google-Sender-Auth: VpW5LbwrHIr2eRhta2_EV5EolD0
Message-ID: <CA+55aFwvFaxBT8Mdp5s4-6Gxy7nM4WVzbWna4RF_OUK3hnx+jQ@mail.gmail.com>
Subject: Re: [PATCH v2] Introduce a version6 of autofs interface, to fix
 design error.
To: David Miller <davem@davemloft.net>
Cc: mjt@tls.msk.ru, linux-kernel@vger.kernel.org, autofs@vger.kernel.org,
        raven@themaw.net, thomas@m3y3r.de, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 11:34 AM, David Miller <davem@davemloft.net> wrote:
>
> If systemd wants to use version 5 of this thing, it has to have the
> same workaround code automountd has.  It is systemd (and now the
> kernel) which is broken.

There's no question that systemd is broken.

But those broken binaries are out in the wild. End of story.

> We should have never touched version 5 of the data-structure.  Having
> 5 years of workaround precedence in userspace proves this.

Umm. The thing is, those broken binaries *work* on 32-bit.  They were
*tested* on 32-bit. They were *shipped* on 32-bit.

And we really do want to make it just work for people to build 64-bit
kernels. It is simply not acceptably to say "hey, you have 32-bit user
land, so use a 32-bit kernel". It's not a different ABI, never has
been.

It's entirely pointless to talk about some next version. THAT FIXES
NOTHING. What's so hard to understand? This is an existing problem,
and making a v6 DOES NOT FIX ANYTHING AT ALL.

And people who bring it up as a "fix" are entirely missing the point.

Seriously.

                      Linus
