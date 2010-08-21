Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521Ab0HUURl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 16:17:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36044 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751009Ab0HUURj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 16:17:39 -0400
MIME-Version: 1.0
In-Reply-To: <20100821200528.GA27421@merkur.ravnborg.org>
References: <20100821193241.GB4760@const.famille.thibault.fr>
 <AANLkTi=Pha8jRFhr+kQfh9doKZDW-=VHq2KqNxXaq6ts@mail.gmail.com>
 <20100821195559.GC4760@const.famille.thibault.fr> <20100821200528.GA27421@merkur.ravnborg.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 21 Aug 2010 13:16:48 -0700
Message-ID: <AANLkTik0EhJVqUxMqXzC9q2AK++ZUje6NM1ki8hEmjUR@mail.gmail.com>
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

On Sat, Aug 21, 2010 at 1:05 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
>
> From said document:
> 15) The canonical patch format
>
> The canonical patch subject line is:
>
>    Subject: [PATCH 001/123] subsystem: summary phrase
>
> The canonical patch message body contains the following:
>
>  - A "from" line specifying the patch author.

Btw, git (and other systems, at least Andrew's patchqueue) also accepts

 - a Subject: line to repeat the subject. This can be useful if you
(for example) want to keep the actual email subject in an old thread,
and thus want to override the email Subject: line with one that is
appropriate for the patch itself.

 - a "Date: " line to specify the date of the patch. Not that most
people care, but when patches get forwarded by email and sign-off's
added, the date of the newer email will obviously change. So _if_ you
care about the date when you actually sent out the patch, you can add
the Date: line to specify the date of the submission, and then as
people forward it, that one may stay around (because it is in the body
of the email)

Quite frankly, I don't personally much care for the "date" line, and
it easily gets lost if a patch is maintained not in email, but in some
other patch queue system (so I think the date line gets dropped if the
patch goes through Andrew, for example). But a patch queue that
doesn't honor the summary and author information isn't a patch queue,
it's a broken mess.

Putting the author line ("From: xyz <abc@example.com>") at the top of
the email body is always a good idea, though. That means that other
people can forward the email, without accidentally then becoming
marked as the author. Of course, careful people will make sure to save
authorship anyway, but mistakes have happened.

(Of course, if you send the patch directly to me or Andrew, you don't
really need to. We both make sure that author information gets saved
off. It tends to be people who aren't quite as used to emailed patches
that get this wrong).

                                    Linus
