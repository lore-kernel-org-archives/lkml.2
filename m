Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970Ab1EDRpk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 13:45:40 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51749 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109Ab1EDRpj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 13:45:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=bPfbOtsVLr093p48SsV0GyoqKqCPZU7sSEq2eMOsUhzdTt7PdasxEbjg0klRbgQ4vp
         bAUCsP/7+kPURSxIdayqpK8q9UwREpS2UA/dywyYD56wUHy2A70s6/vqlUw1NkpKPmMs
         6JtpgsawWkzvVQQi8s6o10eKnEUTNlIrmn+dQ=
MIME-Version: 1.0
In-Reply-To: <m3d3jybjf3.fsf@linux-m68k.org>
References: <alpine.DEB.2.00.1105041629390.2629@ayla.of.borg>
	<m3d3jybjf3.fsf@linux-m68k.org>
Date: Wed, 4 May 2011 19:45:37 +0200
X-Google-Sender-Auth: uW1nTvV1YV7793b-Z5BkKiDNWCY
Message-ID: <BANLkTind9TLfuyVmRnRZJotFPgOebwf-dw@mail.gmail.com>
Subject: Re: [PATCH] m68k/atari: Do not use "/" in interrupt names
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: "Linux/m68k" <linux-m68k@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 4, 2011 at 17:00, Andreas Schwab <schwab@linux-m68k.org> wrote:
> Geert Uytterhoeven <geert@linux-m68k.org> writes:
>> diff --git a/arch/m68k/atari/atakeyb.c b/arch/m68k/atari/atakeyb.c
>> index e1ada31..779efdc 100644
>> --- a/arch/m68k/atari/atakeyb.c
>> +++ b/arch/m68k/atari/atakeyb.c
>> @@ -572,7 +572,7 @@ int atari_keyb_init(void)
>>       kb_state.len = 0;
>>
>>       error = request_irq(IRQ_MFP_ACIA, atari_keyboard_interrupt,
>> -                         IRQ_TYPE_SLOW, "keyboard/mouse/MIDI",
>> +                         IRQ_TYPE_SLOW, "keyboard:mouse:MIDI",
>
> The name is not a path, but an enumeration, so the slash should probably
> be changed to a comma instead.

I thought about that, but comma (albeit followed by a space) is also used to
separate multiple interrupt handlers for shared interrupts.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
