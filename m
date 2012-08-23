Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030564Ab2HWPhZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 11:37:25 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:38418 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755479Ab2HWPhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 11:37:19 -0400
MIME-Version: 1.0
In-Reply-To: <CA+mBkFXnOB9hPoJVf6c92UuemqtLJwc2KW-G-ja6cG8VqLPZdw@mail.gmail.com>
References: <1345551531-15348-1-git-send-email-stany.marcel@novasys-ingenierie.com>
	<CAMuHMdUo5UPLtUhf6_GafMj_kEnM25k+XYszdwsGwkGyCUC6zw@mail.gmail.com>
	<CA+mBkFXnOB9hPoJVf6c92UuemqtLJwc2KW-G-ja6cG8VqLPZdw@mail.gmail.com>
Date: Thu, 23 Aug 2012 17:37:19 +0200
X-Google-Sender-Auth: NElAsvp1T_sqdhyiltGJdBCABsw
Message-ID: <CAMuHMdXSikK0CVs2M+mGGQ4+uwLVCb=wDUWFX9UDTYvt_F58Nw@mail.gmail.com>
Subject: Re: [PATCH 1/3] Add support to broadcom 5222 PHY
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stany MARCEL <stany.marcel@novasys-ingenierie.com>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stany,

On Thu, Aug 23, 2012 at 5:21 PM, Stany MARCEL
<stany.marcel@novasys-ingenierie.com> wrote:
> On Thu, Aug 23, 2012 at 12:47 PM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
>> On Tue, Aug 21, 2012 at 2:18 PM, Stany MARCEL
>> <stany.marcel@novasys-ingenierie.com> wrote:
>>> Signed-off-by: Stany MARCEL <stany.marcel@novasys-ingenierie.com>
>>> ---
>>>
>>>  This driver is an adaption of the one given by freescale for kernel 2.6.25.
>>>
>>>  Tested with kernel 3.4.8 with arch/m68k backported from linux-m68k head
>>>  2 FEC configured with shared phy
>>>
>>>  drivers/net/phy/Kconfig        |    7 +-
>>>  drivers/net/phy/Makefile       |    1 +
>>>  drivers/net/phy/broadcom522x.c |  171 ++++++++++++++++++++++++++++++++++++++++
>>
>> This patch and "[PATCH 3/3] Add support to M54xx DMA FEC Driver" need to go
>> through the netdev tree, or collect acks there.
>
> Please, what is the good process to follow as patch 3 depends on patch 1 ?
>
> Submit 1 to m68k tree and wait for it to be pulled on mainline then
> push 3 to netdev tree ?

Just make sure to add netdev@vger.kernel.org to the CC list, and mention in the
introductory email that you want to collect acks from the netdev maintainer
for patches 1 and 3. After that all 3 patches can go via Greg's m68knommu
tree (for Coldfire).

Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
