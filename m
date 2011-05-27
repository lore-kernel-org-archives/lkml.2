Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758716Ab1E0I0r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 04:26:47 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:52454 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758313Ab1E0I0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 04:26:45 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah0HAPhf301tg2dL/2dsb2JhbABUmCuOCnmIcLwFDoYOBJd9h1o
Date: Fri, 27 May 2011 10:26:40 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: vkuzmichev@mvista.com
Cc: linux-arm-kernel@lists.infradead.org, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk
Subject: Re: [PATCH 0/4] ARM: smp_twd: mpcore_wdt: Fix MPCORE watchdog setup
Message-ID: <20110527082640.GC16394@infomag.iguana.be>
References: <1286185540-19569-1-git-send-email-vkuzmichev@mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286185540-19569-1-git-send-email-vkuzmichev@mvista.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vitaly,

> From: Vitaly Kuzmichev <vkuzmichev@mvista.com>
> 
> The series of patches fixes various bugs in ARM MPCORE watchdog setup.
> They also introduce some changes in common SMP_TWD timer setup code.
> The PATCH 1/4 adds an exported function to obtain calibrated timer rate
> in mpcore_wdt. However, this solution might be unacceptable, so we may
> discuss another 2 variants:
>  1) use clock framework
>    This may require to fix all MPCORE boards clock implementations.
>  2) copy calibration loop to mpcore_wdt
>    However, this increases boot time.
> 
> 
> Vitaly Kuzmichev (4):
>   ARM: smp_twd: mpcore_wdt: Fix watchdog counter loading
>   ARM: smp_twd: Fix typo in twd_timer_rate printout
>   ARM: mpcore_wdt: Fix WDIOC_SETOPTIONS handling
>   ARM: mpcore_wdt: Fix timer mode setup
> 
>  arch/arm/include/asm/smp_twd.h |    7 +++++++
>  arch/arm/kernel/smp_twd.c      |    8 +++++++-
>  drivers/watchdog/mpcore_wdt.c  |   29 +++++++++++++++++++++--------
>  3 files changed, 35 insertions(+), 9 deletions(-)

What's the status on this? I don't recall having seen any answers from ARM community.

Kind regards,
Wim.

