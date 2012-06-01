Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965130Ab2FATnc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 15:43:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26044 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759223Ab2FATna (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 15:43:30 -0400
Message-ID: <4FC91B50.6080101@redhat.com>
Date: Fri, 01 Jun 2012 14:43:12 -0500
From: Dean Nelson <dnelson@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Meelis Roos <mroos@linux.ee>, Jean Delvare <khali@linux-fr.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: f71805f arch dependencies?
References: <alpine.SOC.1.00.1206011559370.10517@math.ut.ee> <CAMuHMdXtZg7JJ18Ao+yLJ5s-vHt38Omgp=b4vOOFet870Buuzw@mail.gmail.com> <alpine.SOC.1.00.1206011610060.10517@math.ut.ee> <CAMuHMdVLkueZdpjht9kL9s9qKv=YT18AVTCoYDmJyKLD=KQ4dg@mail.gmail.com>
In-Reply-To: <CAMuHMdVLkueZdpjht9kL9s9qKv=YT18AVTCoYDmJyKLD=KQ4dg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2012 08:23 AM, Geert Uytterhoeven wrote:
> On Fri, Jun 1, 2012 at 3:12 PM, Meelis Roos<mroos@linux.ee>  wrote:
>>>> Loading f71805f on sparc64 causes hard reboot beacuse on invalid
>>>> hardware access. Should this driver be restricted to PC, or some wider
>>>> subset of platforms where this LPC SUper-IO chip is present?
>>>
>>> Which tree is f71805f in? Not in Linus'.
>>
>> Running upstream 3.4.0-09547-gfb21aff and it is there as
>> SENSORS_F71805F.
>>
>> In fact, there are more LPC hwmon drivers that people can use to "shoot
>> themselves in the leg" - SMSC LPC*, SMSC SCH*, SMSC DME1737 (partly I2C,
>> partly ISA IO), and Fintek F71882FG and compatibles. Maybe more.
>
> Sorry, I thought it was a git SHA1 commit ID.
> Didn't know hardware manufacturers christen their chips to the abbreviated
> commit ID in their VHDL repository ;-)
>
> Indeed, it seems commit 746cdfbf01c0a30d59f6e1b6942d432658d7c7cd
> ("hwmon: Avoid building drivers for powerpc that read/write ISA addresses")
> was a bit too limited...

I lack the hardware expertise to take the SENSORS_ Kconfig changes any
further than I did. As it was, I got much direction from Jean in what I
did do.

So feel free to take it further as you (or whomever) sees fit.

Thanks,
Dean


>
> Gr{oetje,eeting}s,
>
>                          Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                  -- Linus Torvalds
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

