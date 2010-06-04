Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472Ab0FDGxI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 02:53:08 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57112 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823Ab0FDGxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 02:53:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=bwvrflj8T3R5122ev6Jt4JYyksDtkLebj8zaWq1QQCSatQj3kpX3TUMM1KfrNcRP2b
         a8HMxg8+vfwQ/pjEp/4h8fVKU1whQsb0ArE64ncsuAQXnaqTyncpEY0S5Ii6nza/U2ef
         mEl7sng1wcKCtT5GKEkDPJFTUFjBwZbOOGynY=
MIME-Version: 1.0
In-Reply-To: <AANLkTimCXB5r5unDgcZApyO0hbCSYgNgZNV-aHrxg12E@mail.gmail.com>
References: <20100603074548.GA12104@flint.arm.linux.org.uk>
	<alpine.LFD.2.00.1006030725420.8175@i5.linux-foundation.org>
	<20100603164623.GM30622@atomide.com>
	<20100603181303.GB25779@flint.arm.linux.org.uk>
	<1275613325.1931.849.camel@pasglop>
	<AANLkTimCXB5r5unDgcZApyO0hbCSYgNgZNV-aHrxg12E@mail.gmail.com>
Date: Fri, 4 Jun 2010 08:53:02 +0200
X-Google-Sender-Auth: ISBQa6mHTjsXG07izBF8gJ2kgBs
Message-ID: <AANLkTimueDy3WjOoy6dTveSLxU4J2MIOkjAUzYhsSNQu@mail.gmail.com>
Subject: Re: ARM defconfig files
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Russell King <rmk@arm.linux.org.uk>, Tony Lindgren <tony@atomide.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Daniel Walker <dwalker@codeaurora.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arm-msm@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 4, 2010 at 08:30, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On Fri, Jun 4, 2010 at 03:02, Benjamin Herrenschmidt
> <benh@kernel.crashing.org> wrote:
>> On Thu, 2010-06-03 at 19:13 +0100, Russell King wrote:
>>> On Thu, Jun 03, 2010 at 07:46:23PM +0300, Tony Lindgren wrote:
>>> > Compiling in multiple ARM platforms is trickier, we would have to get
>>> > rid of the duplicate defines like NR_IRQS, then have some common clock
>>> > framework etc. Then figure out some way to get rid of Makefile.boot.
>>> > Russell probably has some other things in mind that would have to be
>>> > changed to make this happen.
>>
>> Ok so multiple platforms in one kernel is a different subject and could
>
> Supporting multiple platforms matters a lot to keep everything (not just defconfigs)
> under control.
>
> Technically, on m68k we only need two defconfigs: sun3_defconfig (Sun 3 doesn't
> use a Motorola MMU) and multi_defconfig (which is the logical OR of all the other
> defconfigs, and which should work on all non-Sun 3).

Ah, I forgot...

But indeed, most of the churn when updating the defconfigs (hmm, it's
been a while I submitted an
update) is in the non-arch part: disabling zillions of new options we
don't want.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
