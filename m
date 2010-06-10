Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759653Ab0FJREe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 13:04:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41574 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753117Ab0FJREb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 13:04:31 -0400
MIME-Version: 1.0
In-Reply-To: <20100610164048.GA25171@lst.de>
References: <4C10EC2A.8060002@fusionio.com>
	<AANLkTimus1Ajk-6HyDtZBmsYwQjkAf3zW-dvxNJlSlGw@mail.gmail.com>
	<4C1111ED.6020008@fusionio.com>
	<20100610164048.GA25171@lst.de>
Date: Thu, 10 Jun 2010 10:03:55 -0700
Message-ID: <AANLkTilnMnUhOFecDdqDJrkGki-6HeDMH4sVGp0lN66g@mail.gmail.com>
Subject: Re: [GIT PULL] block/io bits for 2.6.35-rc
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <jaxboe@fusionio.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 10, 2010 at 9:40 AM, Christoph Hellwig <hch@lst.de> wrote:
>
> Maybe give it a bit more beating in linux-next and send it off to Linus
> once he's back from his vacation?

Yes, I'd probably be happier with that. As long as it's "just" a
performance regression (and clearly not one that actually affects most
people all that noticeably), I'd much rather not have to worry about
any potential new issues being introduced right now.

So I'm more looking for "let's fix catastrophic events" for -rc3.
After I get back, I'm way more open to "let's fix any real bugs",
because then I can at least react to any fallout.

(I'm planning on trying to roughly keep up on email etc - I'm today
doing all my email using gmail to test how well that works as an
alternative to my usual "inside two firewalls" behavior. But I'm
seriously trying to avoid even having a laptop with me, because if I
have something where I can do kernel development and git pulls, I know
I'm not going to be just on vacation).

                    Linus
