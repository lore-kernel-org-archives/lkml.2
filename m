Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021Ab0KCLDc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 07:03:32 -0400
Received: from outbound.icp-qv1-irony-out3.iinet.net.au ([203.59.1.148]:23347
	"EHLO outbound.icp-qv1-irony-out3.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753209Ab0KCLD3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 07:03:29 -0400
X-Greylist: delayed 555 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Nov 2010 07:03:29 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApEBAK7b0EzL2THB/2dsb2JhbAAH336FRgSNdg
X-IronPort-AV: E=Sophos;i="4.58,288,1286121600"; 
   d="scan'208";a="652437627"
Subject: Re: [W1] a driver for DS2405 chip
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Ben Nizette <bn@niasdigital.com>
In-Reply-To: <4CD06C22.20204@o2.pl>
Date: Wed, 3 Nov 2010 21:54:12 +1100
Cc: Jonathan Cameron <jic23@cam.ac.uk>, johnpol@2ka.mipt.ru,
        linux-kernel@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>
Content-Transfer-Encoding: 8BIT
Message-Id: <6B41915B-1667-4CA1-A73A-45B043ED8C11@niasdigital.com>
References: <4CC9E2A5.2010400@o2.pl> <4CCEB42F.8000102@cam.ac.uk> <4CD06C22.20204@o2.pl>
To: Maciej Szmigiero <mhej@o2.pl>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 03/11/2010, at 6:53 AM, Maciej Szmigiero wrote:

> W dniu 01.11.2010 13:35, Jonathan Cameron pisze:
>> On 10/28/10 21:52, Maciej Szmigiero wrote:
>>> [W1] a driver for DS2405 chip
>>> 
>>> This is a driver for DS2405 1-wire single-channel addressable switch / PIO.
>>> DS2405 can also work as single-channel binary remote sensor.
>> Perhaps handle this as a gpio chip? (be it a fairly limited one)
>> To my mind it would make it more generally useful...
> 
> I think the GPIO infrastructure is meant for on-system GPIOs, where 1-wire devices are mostly 
> used for remote data acquisition.

Nope!  The contents of drivers/gpio is split roughly 50/50 between on- and off-chip gpio expanders. 

> That's probably why w1_therm (for 1-wire thermometers) is not integrated with HWMON subsystem.

Don't know why this is but kinda sounds like it should be looked at more closely - conceptually 1-W is just another bus like, eg, SPI.

	--Ben.

> 
> Maciej Szmigiero
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

