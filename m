Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736Ab2G3Jl6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 05:41:58 -0400
Received: from nbd.name ([46.4.11.11]:50300 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751515Ab2G3Jl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 05:41:57 -0400
Message-ID: <501656C0.9030609@openwrt.org>
Date: Mon, 30 Jul 2012 11:41:20 +0200
From: John Crispin <blogic@openwrt.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Icedove/3.1.16
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Thomas Langer <thomas.langer@lantiq.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] OF: pinctrl: MIPS: lantiq: adds support for FALCON
 SoC
References: <1343112660-12245-1-git-send-email-blogic@openwrt.org>	<1343112660-12245-3-git-send-email-blogic@openwrt.org> <CACRpkdYP8PdcnS2h_-+n9ZdBmMuBPUv9so9WsUyS-X5rMz1qsQ@mail.gmail.com>
In-Reply-To: <CACRpkdYP8PdcnS2h_-+n9ZdBmMuBPUv9so9WsUyS-X5rMz1qsQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/07/12 01:23, Linus Walleij wrote:
> On Tue, Jul 24, 2012 at 8:50 AM, John Crispin <blogic@openwrt.org> wrote:
>
>> Implement support for pinctrl on lantiq/falcon socs. The FALCON has 5 banks
>> of up to 32 pins.
>>
>> Signed-off-by: John Crispin <blogic@openwrt.org>
>> Signed-off-by: Thomas Langer <thomas.langer@lantiq.com>
>> Cc: Linus Walleij <linus.walleij@linaro.org>
>> Cc: devicetree-discuss@lists.ozlabs.org
>> Cc: linux-kernel@vger.kernel.org
> No big issues and looking really sweet so:
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
>
>> --- a/arch/mips/lantiq/Kconfig
>> +++ b/arch/mips/lantiq/Kconfig
>> @@ -20,6 +20,7 @@ config SOC_XWAY
>>
>>  config SOC_FALCON
>>         bool "FALCON"
>> +       select PINCTRL_FALCON
> I think you need to add "select PINCTRL" above "select PINCTRL_FALCON"
> for this to work.
>
> Atleast I had to do that in the past to get things working.

Hi Linus,

config LANTIQ selects PINCTRL  globally for all Lantiq SoC so an
explicit select can be avoided here

Thanks for the review,
John
