Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865Ab1FSWVb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 18:21:31 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:44539 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754781Ab1FSWV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 18:21:29 -0400
MIME-Version: 1.0
In-Reply-To: <1308494508.13047.4.camel@thorin>
References: <BANLkTik9HzR_oJ7FocQ=o+zNoK22tUTjBg@mail.gmail.com>
	<1308418985.3539.58.camel@edumazet-laptop>
	<BANLkTi=Vis=aZ5vn7E0A2LGVPOcmjd+r-g@mail.gmail.com>
	<20110618193340.53811cbe@lxorguk.ukuu.org.uk>
	<BANLkTi=bvmtkv-o3PROYjmOwkBNCBFGv7w@mail.gmail.com>
	<1308494508.13047.4.camel@thorin>
Date: Sun, 19 Jun 2011 15:21:27 -0700
Message-ID: <BANLkTimAxbVWzahU8Ke_Rb8bgiVVrsihRA@mail.gmail.com>
Subject: Re: Does Linux select() violate POSIX?
From: Nemo Publius <nemo@self-evident.org>
To: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Eric Dumazet <eric.dumazet@gmail.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 19, 2011 at 7:41 AM, Bernd Petrovitsch
<bernd@petrovitsch.priv.at> wrote:
> On Sam, 2011-06-18 at 11:51 -0700, Nemo Publius wrote:
>
> Then you should reformulate your question because the answer is
> technically correct.

First of all, had you bothered to read the very next sentence in the
Email to which you felt the need to reply, you would find I did
precisely that:

    "Of course I am talking about select() followed by recv() without
any intervening user-space operations on the descriptor."

Second, you are wrong.  I basically asked, "Is select() followed by
recv() guaranteed not to block?"

Possible answers include:

"No; your computer might crash."

"No; your kernel image might be corrupt."

"No; space aliens might destroy the earth."

"No; some other process might access the descriptor in the meantime."

All of these are "technically" correct.  All of them are also
completely useless.  You -- and everyone else who read my question --
know _exactly_ what I was asking.

And I got my answer, which is yes, Linux select() violates POSIX, and
that decision is deliberate.

But again, thank you so much for your valuable contribution to the discussion.
