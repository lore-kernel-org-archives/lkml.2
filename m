Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932281Ab1CaFpz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 01:45:55 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35384 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755303Ab1CaFpy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 01:45:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=S8cbuzTwFgiTAIK3F6dz9DGNcv9e7WXq2nmX48LSgxCO6v9UBmaCKBm2gcoLSF3fhk
         2+NVS40MYH2qodZdABDhD4xdCH1tedWpjDhepIz32KSPAxdCgtCzDqX0E3OaKp+LBIr0
         w9Jk44Q8vJ+FgKujV/O0B99VdGC2BL4wa3JWk=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1103301814250.28032@xanadu.home>
References: <20110317183048.GW7258@atomide.com>
	<AANLkTimWbb5DWiiCW821H6pRicbk1fS3PYcnGyUMznvM@mail.gmail.com>
	<20110318101512.GA15375@n2100.arm.linux.org.uk>
	<201103301906.42429.arnd@arndb.de>
	<AANLkTim578-kwM14SJd06RW_QiC4WVCmFuG+ASgGC4sq@mail.gmail.com>
	<alpine.LFD.2.00.1103301531420.28032@xanadu.home>
	<AANLkTim6zg-U6HtAQbqnENqoK7x8erXSqOuTFVC0YE5r@mail.gmail.com>
	<alpine.LFD.2.00.1103301814250.28032@xanadu.home>
Date: Thu, 31 Mar 2011 07:45:53 +0200
X-Google-Sender-Auth: JysmV3u193r51pHDm1bIxeID3eY
Message-ID: <AANLkTimZ8+npVu6u5-o9+3CV40wB_GYwiOWvfJPso8G0@mail.gmail.com>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, David Brown <davidb@codeaurora.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 31, 2011 at 01:31, Nicolas Pitre <nico@fluxnic.net> wrote:
> On Wed, 30 Mar 2011, Linus Torvalds wrote:
>> The long-term situation should be that you should be able to have ONE
>> binary kernel "just work". That's where we are on x86. Really.
>
> But X86 is peanuts.  Really.  There was one machine called the IBM PC at
> some point that everybody cloned, and the rest was totally irrelevant.
> Then came that thing called Windows that reinforced this hardware
> monoculture as it was used for the ultimate conformance testing.  This
> is damn easy in that case to produce a kernel that works virtually
> everywhere.
>
> On ARM there is simply not such thing as a single machine design to
> clone, and a closed source test bench to design for.

There are other architectures that didn't start from a single root platform,
but still support multi-platform kernels.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
