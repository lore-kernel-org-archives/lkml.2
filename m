Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667Ab2GXIVS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 04:21:18 -0400
Received: from nbd.name ([46.4.11.11]:54776 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755621Ab2GXIVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 04:21:13 -0400
Message-ID: <500E5AE2.6020207@openwrt.org>
Date: Tue, 24 Jul 2012 10:20:50 +0200
From: John Crispin <blogic@openwrt.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Icedove/3.1.16
MIME-Version: 1.0
To: "Langer Thomas (LQDE RD ST PON SW)" <thomas.langer@lantiq.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/6] GPIO: MIPS: add gpio driver for flacon SoC
References: <1343112660-12245-1-git-send-email-blogic@openwrt.org> <1343112660-12245-5-git-send-email-blogic@openwrt.org> <593AEF6C47F46446852B067021A273D6060CEA@MUCSE039.lantiq.com>
In-Reply-To: <593AEF6C47F46446852B067021A273D6060CEA@MUCSE039.lantiq.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/07/12 10:09, Langer Thomas (LQDE RD ST PON SW) wrote:
> Hello John,
>
> John Crispin wrote on 2012-07-24:
>> Add driver for GPIO blocks found on Lantiq FALCON SoC. The SoC has 5
>> banks of up to 32 pads. The GPIO blocks have a per pin IRQs.
>>
>> Signed-off-by: John Crispin <blogic@openwrt.org>
>> Signed-off-by: Thomas Langer <thomas.langer@lantiq.com>
>> Cc: linux-kernel@vger.kernel.org
>> ---
>>  arch/mips/include/asm/mach-lantiq/gpio.h |    4 +
>>  drivers/gpio/Kconfig                     |    5 +
>>  drivers/gpio/Makefile                    |    1 +
>>  drivers/gpio/gpio-falcon.c               |  355 ++++++++++++++++++++++++++++++
>>  4 files changed, 365 insertions(+), 0 deletions(-)
>>  create mode 100644 drivers/gpio/gpio-falcon.c
> Please fix the spelling error in the subject!
>
> Best Regards,
> Thomas

Hi Thomas,

nice catch

thanks,
John

