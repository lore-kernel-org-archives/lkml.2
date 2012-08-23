Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757411Ab2HWMgY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 08:36:24 -0400
Received: from dnvwsmailout1.mcafee.com ([161.69.31.173]:61980 "EHLO
	DNVWSMAILOUT1.mcafee.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390Ab2HWMgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 08:36:21 -0400
Message-ID: <5036234A.7060102@snapgear.com>
Date: Thu, 23 Aug 2012 22:34:18 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Stany MARCEL <stany.marcel@novasys-ingenierie.com>
CC: Geert Uytterhoeven <geert@linux-m68k.org>, <linux-m68k@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] Add support to broadcom 5222 PHY
References: <1345551531-15348-1-git-send-email-stany.marcel@novasys-ingenierie.com> <CAMuHMdUo5UPLtUhf6_GafMj_kEnM25k+XYszdwsGwkGyCUC6zw@mail.gmail.com>
In-Reply-To: <CAMuHMdUo5UPLtUhf6_GafMj_kEnM25k+XYszdwsGwkGyCUC6zw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stany,

On 08/23/2012 08:47 PM, Geert Uytterhoeven wrote:
> On Tue, Aug 21, 2012 at 2:18 PM, Stany MARCEL
> <stany.marcel@novasys-ingenierie.com> wrote:
>> Signed-off-by: Stany MARCEL <stany.marcel@novasys-ingenierie.com>
>> ---
>>
>>   This driver is an adaption of the one given by freescale for kernel 2.6.25.
>>
>>   Tested with kernel 3.4.8 with arch/m68k backported from linux-m68k head
>>   2 FEC configured with shared phy
>>
>>   drivers/net/phy/Kconfig        |    7 +-
>>   drivers/net/phy/Makefile       |    1 +
>>   drivers/net/phy/broadcom522x.c |  171 ++++++++++++++++++++++++++++++++++++++++
>
> This patch and "[PATCH 3/3] Add support to M54xx DMA FEC Driver" need to go
> through the netdev tree, or collect acks there.

And patch 2/3 never made it to the linux-m68k list. Though I can see
that it made it onto the linux-kernel list.

I would suggest running them through checkpatch, there is a number of
formating and the like issues that need cleaning up.

Also you will want to break up patch 2. It is a bit large to be reviewed
the way it is.

Regards
Greg


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
> To unsubscribe from this list: send the line "unsubscribe linux-m68k" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close,                            FAX:         +61 7 3891 3630
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
