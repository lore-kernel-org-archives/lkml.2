Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932416Ab0CaII6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 04:08:58 -0400
Received: from mta-2.ms.rz.RWTH-Aachen.DE ([134.130.7.73]:56845 "EHLO
	mta-2.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932177Ab0CaIIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 04:08:54 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-15
X-IronPort-AV: E=Sophos;i="4.51,340,1267398000";   d="scan'208";a="51051660"
Message-id: <4BB30304.7060300@nets.rwth-aachen.de>
Date: Wed, 31 Mar 2010 10:08:36 +0200
From: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8)
 Gecko/20100322 Lightning/1.0b2pre Thunderbird/3.0.3
To: Martin Teufel <teufel@informatik.uni-frankfurt.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: AMD Geode LX WDT (geode-mfgpt)
References: <20100331045414.GA3241@hekate.rbi.informatik.uni-frankfurt.de>
In-reply-to: <20100331045414.GA3241@hekate.rbi.informatik.uni-frankfurt.de>
X-Enigmail-Version: 1.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 31.03.2010 06:54, schrieb Martin Teufel:

> I have some ALIX boards (SBC) with AMD Geode LX CPUs and their companion
> device CS5536 and am using Debian on them. I didn't care about the
> integrated watchdog timer (in the CS5536) so far. Recently I did, but
> neither the CONFIG_GEODE_WDT was set in the debian kernel (2.6.26), nor
> the CONFIG_GEODE_MFGPT_TIMER. So I compiled my own debian 2.6.26 geode
> kernel (CONFIG_MGEODE_LX=y, CONFIG_GEODE_WDT=y,
> CONFIG_GEODE_MFGPT_TIMER=y, CONFIG_CRYPTO_DEV_GEODE=y etc.).
> 
> My problem is that the geode-mfgpt doesn't find any timers:
> 
> [    0.204012] geode-mfgpt:  0 MFGPT timers available.
> [    0.208013] mfgpt-timer:  Could not allocate a MFPGT timer
> ...
> [    2.284029] geodewdt:  No timers were available
> 
> My question is: Why doesn't it? Is this a known bug? If so, is it
> already fixed in a newer kernel version?

Your BIOS may already use all available timers.
AFAIR only TinyBios with ALIX leaves timers for the OS.
Award and CoreBoot both use them all.

Best regards,
Arnd
