Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758288Ab2ECTTK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 15:19:10 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:51934 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755924Ab2ECTTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 15:19:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH 00/02] mach-shmobile: Emma Mobile EV2 - first shot
Date: Thu, 3 May 2012 21:23:55 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, horms@verge.net.au,
        linux@arm.linux.org.uk, arnd@arndb.de, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, lethal@linux-sh.org, olof@lixom.net
References: <20120503144645.6390.62303.sendpatchset@w520>
In-Reply-To: <20120503144645.6390.62303.sendpatchset@w520>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201205032123.55535.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 03, 2012, Magnus Damm wrote:
> mach-shmobile: Emma Mobile EV2 - first shot
> 
> [PATCH 01/02] mach-shmobile: Emma Mobile EV2 SoC base support
> [PATCH 02/02] mach-shmobile: KZM9D board prototype support
> 
> This series adds experimental Emma Mobile EV2 support to
> mach-shmobile. Yet another dual core Cortex-A9 SoC.
> 
> At this point only serial and timer is supported. Future work
> includes GPIO, network device, SMP and DT support. If possible
> it would be nice to use the common clocks on this platform.
> 
> To boot this on actual hardware you also need the following:
> "[PATCH] serial8250-em: Emma Mobile UART driver V2"
> "[PATCH] clocksource: em_sti: Emma Mobile STI driver"
> 
> Any reason to not put this in mach-shmobile?
> 
> Partially-signed-off-by: Magnus Damm <damm@opensource.se>
> ---
> 
>  Does unfortunately not apply cleanly to the renesas
>  git repository,

Well, this sounds like a reason.

>  so we need to figure out how to let
>  this coexist with the new boards...

Surely.

Thanks,
Rafael


>  arch/arm/mach-shmobile/Kconfig               |    9 +
>  arch/arm/mach-shmobile/Makefile              |    2 
>  arch/arm/mach-shmobile/board-kzm9d.c         |   44 +++++
>  arch/arm/mach-shmobile/clock-emev2.c         |  206 ++++++++++++++++++++++++++
>  arch/arm/mach-shmobile/include/mach/common.h |    6 
>  arch/arm/mach-shmobile/intc-emev2.c          |   36 ++++
>  arch/arm/mach-shmobile/setup-emev2.c         |  187 +++++++++++++++++++++++
>  7 files changed, 490 insertions(+)
> 
> 

