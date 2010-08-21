Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152Ab0HUTpf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 15:45:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40606 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751478Ab0HUTpe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 15:45:34 -0400
MIME-Version: 1.0
In-Reply-To: <20100821193241.GB4760@const.famille.thibault.fr>
References: <20100821193241.GB4760@const.famille.thibault.fr>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 21 Aug 2010 12:45:12 -0700
Message-ID: <AANLkTi=Pha8jRFhr+kQfh9doKZDW-=VHq2KqNxXaq6ts@mail.gmail.com>
Subject: Re: [PATCH,TRIVIAL] Replace Configure with Enable in description of MAXSMP
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, Nick Piggin <npiggin@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 21, 2010 at 12:32 PM, Samuel Thibault
<samuel.thibault@ens-lyon.org> wrote:
>
> Replace Configure with Enable in description of MAXSMP
>
> The "Configure" word tends to make user believe they have to say 'yes'
> to be able to choose the number of procs/nodes.  "Enable" should be
> unambiguous enough.

What broken patch-generation tools do you use, btw? Nick Piggin has
the same problem: the Subject of the patch gets repeated as the first
line of the body of the thing, which is very annoying. Either I have
to go in and edit the email (which I try to do), or the thing gets
repeated in the commit message.

Yes, the summary line is interesting, but it's _not_ interesting
enough that people want to see it twice.

(See commit 99b7db7b8ffd for an example of where it got repeated twice
- Al Viro isn't as anal as me about commit messages, and clearly
didn't edit the email before applying it).

If you want to repeat the summary line, please repeat the "Subject:"
part of the line too, so that the tools automatically see that it's
just a repeat of the Subject: line. Same goes if you want to add
author information: make sure that the author information has that
"From: " prepended to it.

And if it really is a tool that creates these buggy patch messages
with duplicate summary information, please let's just fix that buggy
crud.

I edited this by hand, but it annoys me when I have to do mindless
silly stuff just because people submit broken patch descriptions.

                                   Linus
