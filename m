Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758165Ab1EaIxJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 04:53:09 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58787 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544Ab1EaIxH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 04:53:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=LNNF5Z2eXQwnM+jHBVz+O691jwDwCkv0GYxHtg5kBjX4jRiHIxVl7OWFC9xkMj5zky
         2N/lOPEsPrsVFTFbo19pZ3j6cGxjn8qGtBFjMp0E19UXuZ6hPgKEhZ4bKzx2/K9l/s4X
         n1qddmshBcaIkdbBBu7Hk7z2cXpLqDa+W9WHk=
MIME-Version: 1.0
In-Reply-To: <20110530102502.GC17821@elte.hu>
References: <1306707270.2029.377.camel@i7.infradead.org>
	<20110530072300.GA9802@elte.hu>
	<1306745835.2029.389.camel@i7.infradead.org>
	<20110530091536.GA2827@elte.hu>
	<1306747629.2029.397.camel@i7.infradead.org>
	<20110530095333.GA8461@elte.hu>
	<1306750004.2029.413.camel@i7.infradead.org>
	<20110530102502.GC17821@elte.hu>
Date: Tue, 31 May 2011 10:53:05 +0200
X-Google-Sender-Auth: E8BLDj_TlbSPMzalx18pui66Ncg
Message-ID: <BANLkTi=X2PzoqJy_dY0oBA9=y_hGt-fX4g@mail.gmail.com>
Subject: Re: [PATCH] Fix corruption of CONFIG_X86_32 in 'make oldconfig'
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Woodhouse <dwmw2@infradead.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 30, 2011 at 12:25, Ingo Molnar <mingo@elte.hu> wrote:
>> > I personally prefer 'make ARCH=i386 defconfig' and 'make ARCH=x86_64
>> > defconfig' because it's a nice conceptual equivalent to:
>> >
>> >     make ARCH=arm defconfig
>> >     make ARCH=mips defconfig
>>
>> No, ARCH= is just for cross-compiling. If you're *on* an ARM or MIPS
>> box, you don't need the ARCH= bit.
>
> Still note that 'make ARCH=arm defconfig' will just work fine even
> without cross-building, so i often use just that if i want to see
> what default core kernel options ARM (or MIPS) has enabled these
> days.

That's still the first part of "cross-building", so the issue is moot.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
