Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327Ab1EaOOH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 10:14:07 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39826 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368Ab1EaOOE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 10:14:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=eCQrFzUgjUI6NfQOu0tB6GQZvzYKCehJCUvoU/4IxwPQi1OXLnmlsgzACVkuLXzp7q
         GvLfp6Mzvp3WMluu7QdHYIgKqq60UB/xbpT1sm4Sv4hFEWqKgVhURBQo5rrD4b+kqy8g
         7psu9UW7MlrgESEU271aj+0G1YnICdMN1236s=
MIME-Version: 1.0
In-Reply-To: <1306842211.2029.531.camel@i7.infradead.org>
References: <20110530104231.GF17821@elte.hu>
	<20110530104656.GA19532@elte.hu>
	<E934876C-FABB-41F8-8C5E-469AA42DBE91@mit.edu>
	<20110530105809.GA20133@elte.hu>
	<1A4DB87D-9B32-44C0-B7C9-47A003CABD96@mit.edu>
	<alpine.LFD.2.02.1105301955210.3164@localhost6.localdomain6>
	<20110530195545.GG2890@dhcp-172-31-194-241.cam.corp.google.com>
	<alpine.LFD.2.02.1105302103220.3164@localhost6.localdomain6>
	<20110531075306.GB20798@elte.hu>
	<1306832148.2029.484.camel@i7.infradead.org>
	<20110531104106.GD24172@elte.hu>
	<1306842211.2029.531.camel@i7.infradead.org>
Date: Tue, 31 May 2011 16:14:03 +0200
X-Google-Sender-Auth: eNr2K4fpNZZTAogVXKnNW1LVu0E
Message-ID: <BANLkTikWJ-mhVqcbx_f9+uZEKDQGy+TZ7Q@mail.gmail.com>
Subject: Re: [PATCH] Fix corruption of CONFIG_X86_32 in 'make oldconfig'
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, "Ted Ts'o" <tytso@mit.edu>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>,
        Randy Dunlap <rdunlap@xenotime.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 13:43, David Woodhouse <dwmw2@infradead.org> wrote:
> On Tue, 2011-05-31 at 12:41 +0200, Ingo Molnar wrote:
>> * David Woodhouse <dwmw2@infradead.org> wrote:
>> > On Tue, 2011-05-31 at 09:53 +0200, Ingo Molnar wrote:
>> > > I'll always prefer typing:
>> > >   make ARCH=x86_64 ...
>> > > To:
>> > >   make ARCH=x86 CONFIG_64BIT=y ...
>> >
>> > Why else would you need to specify ARCH=x86 on the latter command line?
>>
>> Note that if we are consistent and implement the logical extension of
>> your CONFIG_64BIT 'fix' then we could pick up the target architecture
>> from the .config as well and not use the host architecture.
>
> It would be interesting, perhaps, to make the architecture a config
> option. Distinctly non-trivial, though. I think it's been discussed
> before.

IIRC, that's one of the goals on the kbuild plan.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
