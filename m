Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232Ab2CJUGM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 15:06:12 -0500
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:54005 "EHLO
	new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751987Ab2CJUGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 15:06:08 -0500
X-Sasl-enc: qZjZ9HiQs74UOFN/9SGZ7WXcloRtZUQfE8XeoTCZGfg3 1331409966
Message-ID: <4F5BB42E.3090201@signal11.us>
Date: Sat, 10 Mar 2012 15:06:06 -0500
From: Alan Ott <alan@signal11.us>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Lightning/1.0b2 Thunderbird/3.1.8
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Subject: Re: [PATCH 1/2] ARM: at91: only RM9200 has ISA-style PIO
References: <1331405049-3186-1-git-send-email-alan@signal11.us> <1331405075-3231-1-git-send-email-alan@signal11.us> <201203101924.31710.arnd@arndb.de>
In-Reply-To: <201203101924.31710.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2012 02:24 PM, Arnd Bergmann wrote:
> On Saturday 10 March 2012, Alan Ott wrote:
>> From: Arnd Bergmann <arnd@arndb.de>
>>
>> Most at91 systems have no support for PCMCIA or other
>> PC-style buses, so we can select NO_IOPORT in order to
>> disable compilationf or all drivers that need these.
>>
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>> Signed-off-by: Alan Ott <alan@signal11.us>
> You forgot to Cc the at91 maintainers on this patch (and on patch 0).
> Also, this patch relies on the another series I did to redefine
> the meaning of CONFIG_NO_IOPORT while renaming the existing one to
> CONFIG_NO_IOPORT_MAP. This patch will have to wait for the other
> series.

Hi Arnd,

I'm going to assume you mean randconfig/ioport in
git://git.linaro.org/people/arnd/linux.git .
I'll take this patch out for v2 and make a note that it needs to go with
the patches in randconfig/ioport.

I used scripts/get_maintainers.pl for the recipient list, but I now see
how that failed, since this patch modifies the AT91 section of a file
not in arc/arm/mach-at91.

Alan.

