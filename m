Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751557Ab0HUU2b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 16:28:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56859 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751010Ab0HUU23 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 16:28:29 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTik0EhJVqUxMqXzC9q2AK++ZUje6NM1ki8hEmjUR@mail.gmail.com>
References: <20100821193241.GB4760@const.famille.thibault.fr>
 <AANLkTi=Pha8jRFhr+kQfh9doKZDW-=VHq2KqNxXaq6ts@mail.gmail.com>
 <20100821195559.GC4760@const.famille.thibault.fr> <20100821200528.GA27421@merkur.ravnborg.org>
 <AANLkTik0EhJVqUxMqXzC9q2AK++ZUje6NM1ki8hEmjUR@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 21 Aug 2010 13:27:36 -0700
Message-ID: <AANLkTi=73e9nowip3M8N+5R7R1p=9OR4EYRUHECgQ1Uo@mail.gmail.com>
Subject: Re: [PATCH,TRIVIAL] Replace Configure with Enable in description of MAXSMP
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Nick Piggin <npiggin@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 21, 2010 at 1:16 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Sat, Aug 21, 2010 at 1:05 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
>>
>> The canonical patch message body contains the following:
>>
>>  - A "from" line specifying the patch author.
>
> Btw, git (and other systems, at least Andrew's patchqueue) also accepts
>
>  - a Subject: line [...]
>
>  - a "Date: " line [...]

So Arjan just sent out a patch that does all three. See

  http://lkml.indiana.edu/hypermail/linux/kernel/1008.2/02557.html

for an example.

And note that all those three lines can be dropped. In the absence of
the small "fake email header" at the top of the email body, git (and
again: also other mail applicator tools like the ones Andrew uses)
will take the information from the real email headers. So putting them
in the body is by no means required, but in the body they do end up
being more likely to not be corrupted by further emailing.

It's also a way to fix up a broken email system, for example. Lots of
people have email accounts that screw up their names (interesting
utf-8 characters being turned into regular ascii - for Finns, 'ä'
might be turned into 'a' or 'ae', for example), or maybe you want to
use your work email in the kernel logs, but you're using your home
email to send out the patch etc.

So sometimes the "put the header info at the top of the body" works as
a way to fix up incorrect information in your email headers.

                        Linus
