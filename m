Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016Ab2H0IDz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 04:03:55 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:48554 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab2H0IDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 04:03:53 -0400
Message-ID: <503B29E1.5080901@atmel.com>
Date: Mon, 27 Aug 2012 10:03:45 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
CC: Joachim Eastwood <joachim.eastwood@jotron.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        voice <voice.shen@atmel.com>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [GIT PULL] at91: fixes for 3.6 (take 1)
References: <5037A4F3.9090608@atmel.com>
In-Reply-To: <5037A4F3.9090608@atmel.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.159.245.112]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/2012 05:59 PM, Nicolas Ferre :
> The following changes since commit d9875690d9b89a866022ff49e3fcea892345ad92:
> 
>   Linux 3.6-rc2 (2012-08-16 14:51:24 -0700)
> 
> are available in the git repository at:
> 
>   git://github.com/at91linux/linux-at91.git tags/at91-fixes
> 
> for you to fetch changes up to 0d4d1e37ca732615717d4434b58682f81a6bb61c:
> 
>   ARM: at91/feature-removal-schedule: delay at91_mci removal (2012-08-24 10:45:07 +0200)
> 
> ----------------------------------------------------------------
> Fixes for AT91 related to:
> - move to sparse IRQ: some drivers were forgotten
> - a build error in sound driver & a DTS typo
> - the delay for removal of old at91_mci driver
> 
> ----------------------------------------------------------------
> Bo Shen (1):
>       ARM: at91/dts: remove partial parameter in at91sam9g25ek.dts
> 
> Joachim Eastwood (1):
>       ASoC: atmel-ssc: include linux/io.h for raw io

Hi,

As per Mark's suggestion, this one will go through ASoC tree. So I have
removed it from the tag. I resend a pull request now.

Best regards,


> Ludovic Desroches (3):
>       ARM: at91: fix system timer irq issue due to sparse irq support
>       ARM: at91: fix rtc-at91sam9 irq issue due to sparse irq support
>       ARM: at91/feature-removal-schedule: delay at91_mci removal
> 
> Nicolas Ferre (1):
>       ARM: at91/clock: fix PLLA overclock warning
> 
>  Documentation/feature-removal-schedule.txt |    2 +-
>  arch/arm/boot/dts/at91sam9g25ek.dts        |    2 +-
>  arch/arm/mach-at91/at91rm9200_time.c       |    2 +-
>  arch/arm/mach-at91/at91sam9260_devices.c   |    6 +++++-
>  arch/arm/mach-at91/at91sam9261_devices.c   |    6 +++++-
>  arch/arm/mach-at91/at91sam9263_devices.c   |   10 ++++++++--
>  arch/arm/mach-at91/at91sam9g45_devices.c   |    6 +++++-
>  arch/arm/mach-at91/at91sam9rl_devices.c    |    6 +++++-
>  arch/arm/mach-at91/clock.c                 |   12 ++++++++++++
>  drivers/rtc/rtc-at91sam9.c                 |   22 +++++++++++++++-------
>  include/linux/atmel-ssc.h                  |    1 +
>  11 files changed, 59 insertions(+), 16 deletions(-)
> 
> Thanks, best regards,
> 


-- 
Nicolas Ferre
