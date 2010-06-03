Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719Ab0FCRVW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 13:21:22 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:50598 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754241Ab0FCRVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 13:21:08 -0400
Message-ID: <4C07E461.9000506@metafoo.de>
Date: Thu, 03 Jun 2010 19:20:33 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: Graham Gower <graham.gower@gmail.com>
CC: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 03/26] MIPS: JZ4740: Add clock API support.
References: <1275505397-16758-1-git-send-email-lars@metafoo.de>        <1275505397-16758-4-git-send-email-lars@metafoo.de> <AANLkTimVM637peyrPP7dZ3Uy2S-3DAEXspGi-FONcW6p@mail.gmail.com>
In-Reply-To: <AANLkTimVM637peyrPP7dZ3Uy2S-3DAEXspGi-FONcW6p@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Graham Gower wrote:
> On 3 June 2010 04:32, Lars-Peter Clausen <lars@metafoo.de> wrote:
>
>   
>> +       {
>> +               .name = "dma",
>> +               .parent = &jz_clk_high_speed_peripheral.clk,
>> +               .gate_bit = JZ_CLOCK_GATE_UART0,
>> +               .ops = &jz_clk_simple_ops,
>> +       },
>>     
>
> Presumably this should be JZ_CLOCK_GATE_DMAC.
>
> -Graham
>   
Hi

Yes.

Thanks for reviewing
- Lars
