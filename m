Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759794Ab2FANXH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 09:23:07 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:36925 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381Ab2FANXF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 09:23:05 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.SOC.1.00.1206011610060.10517@math.ut.ee>
References: <alpine.SOC.1.00.1206011559370.10517@math.ut.ee>
	<CAMuHMdXtZg7JJ18Ao+yLJ5s-vHt38Omgp=b4vOOFet870Buuzw@mail.gmail.com>
	<alpine.SOC.1.00.1206011610060.10517@math.ut.ee>
Date: Fri, 1 Jun 2012 15:23:04 +0200
X-Google-Sender-Auth: ATOoZRihiYoAby6sLEkUy9ROvDQ
Message-ID: <CAMuHMdVLkueZdpjht9kL9s9qKv=YT18AVTCoYDmJyKLD=KQ4dg@mail.gmail.com>
Subject: Re: f71805f arch dependencies?
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Meelis Roos <mroos@linux.ee>
Cc: Jean Delvare <khali@linux-fr.org>, Dean Nelson <dnelson@redhat.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 1, 2012 at 3:12 PM, Meelis Roos <mroos@linux.ee> wrote:
>> > Loading f71805f on sparc64 causes hard reboot beacuse on invalid
>> > hardware access. Should this driver be restricted to PC, or some wider
>> > subset of platforms where this LPC SUper-IO chip is present?
>>
>> Which tree is f71805f in? Not in Linus'.
>
> Running upstream 3.4.0-09547-gfb21aff and it is there as
> SENSORS_F71805F.
>
> In fact, there are more LPC hwmon drivers that people can use to "shoot
> themselves in the leg" - SMSC LPC*, SMSC SCH*, SMSC DME1737 (partly I2C,
> partly ISA IO), and Fintek F71882FG and compatibles. Maybe more.

Sorry, I thought it was a git SHA1 commit ID.
Didn't know hardware manufacturers christen their chips to the abbreviated
commit ID in their VHDL repository ;-)

Indeed, it seems commit 746cdfbf01c0a30d59f6e1b6942d432658d7c7cd
("hwmon: Avoid building drivers for powerpc that read/write ISA addresses")
was a bit too limited...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
