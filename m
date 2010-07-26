Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219Ab0GZUL1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 16:11:27 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:46349 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055Ab0GZULZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 16:11:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=j4V90MMZP2WtwAepbYfh7CC75wJMOlBV1CW/bo2DVnCqqNohed9O/HBdDIOFdwq7ui
         pec/0fhLPfd+aV75ooj9LX5UAfmLj2RdKNfIKLMSDuTi8rhv/2teMnBEV0uo5OL38Lf7
         ULQtRK9ptU2rqy67T1zgpeV7FVjdV/324q3To=
MIME-Version: 1.0
In-Reply-To: <loom.20100724T155117-833@post.gmane.org>
References: <AANLkTikitTGpiE5Oe_P5a4f2OCOnlB9j_LVm5CQhQIno@mail.gmail.com>
	<20100722122111.4cf4ca2f@lxorguk.ukuu.org.uk>
	<AANLkTilKJx18oyc815DhKfPv-Yjdv8UmfJ4WTDxZxaab@mail.gmail.com>
	<AANLkTimnxkn5eLRHOAs6v_TJE0hM5=dQ3OWaiQP6tPJd@mail.gmail.com>
	<loom.20100724T155117-833@post.gmane.org>
Date: Mon, 26 Jul 2010 22:11:24 +0200
X-Google-Sender-Auth: gUwAqepDH4MjDvxCLQyNK9l2iBk
Message-ID: <AANLkTi=LAHhHEK3vbtwefroOrpoKpUs5B5=iu5_asMp6@mail.gmail.com>
Subject: Re: Introducing the LCD-Linux project
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: James Simmons <jsimmons@infradead.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 24, 2010 at 16:43, Florian Tobias Schandinat
<FlorianSchandinat@gmx.de> wrote:
> Mattia Jona-Lasinio <mattia.jona <at> gmail.com> writes:
>> Moreover I wanted something that COULD be used as a console but not
>> necessarily, that is
>> something that could run happily in the presence of a normal monitor
>> as well. It seems to me, but I may be
>> wrong, that through the standard console system only the current
>> visible console is actually updated
>> while other consoles are just "software" updated. An external LCD
>> would therefore be updated
>> only when you "switch" to it, so it would not be possible to use it to
>> display diagnostics.
>
> True, that's a general problem one has when multiple framebuffers exist.
> Therefore I'd be very happy if someone could come up with a general solution.

Fixing that was (one of the) goal of the linux-console project. James?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
