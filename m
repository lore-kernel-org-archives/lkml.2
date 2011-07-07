Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550Ab1GGIGJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 04:06:09 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:57742 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143Ab1GGIGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 04:06:02 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH 1/6 v8] ARM: Add basic architecture support for VIA/WonderMedia 85xx SoC's
Date: Thu, 7 Jul 2011 10:05:15 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: vt8500-wm8505-linux-kernel@googlegroups.com,
        Alexey Charkov <alchark@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        Eric Miao <eric.y.miao@gmail.com>,
        "Uwe =?iso-8859-1?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>,
        linux-kernel@vger.kernel.org
References: <1289147348-31969-1-git-send-email-alchark@gmail.com> <201107070954.00419.arnd@arndb.de> <20110707075954.GF8286@n2100.arm.linux.org.uk>
In-Reply-To: <20110707075954.GF8286@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107071005.15497.arnd@arndb.de>
X-Provags-ID: V02:K0:8YQpW5q3VYuvcWCh9ryVpA/9+z1CeEC+wwwgS6UOm/4
 fVHMHYQE8KntIo/7Hhw2h44dPh/3U5EOmMoJ8TAE0mGfd9I4gh
 rYncgXRWLD2u2NoupSwJw37mP3qaKjZnKCMwWuJVu+CxKS8HyX
 X9R/7SZdWZOzrFxtu6mpwlaQuMVR/Ir1i8XHP/ZQrPoUz2k2g9
 oVyeGPzYurisHciOKSMxQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 July 2011 09:59:54 Russell King - ARM Linux wrote:
> > Actually, we did discuss this when I first reviewed your patches. FWIW,
> > WM8505, WM8510 and VT8500 don't seem to have PCI, but VT8430 has PCI,
> > according to the data sheet and the patch provided by VIA.
> > 
> > What made this a little hard to understand is the way that VIA provided
> > an emulated PCI bus even on those platforms that didn't have the hardware,
> > apparently because it didn't occur to them to add platform device
> > support to the network driver (via velocity, iirc). They just faked a
> > configuration space for the USB and network devices to make them work
> > with the regular PCI drivers.
> 
> Ok, so it can use the default value I've created for IO_SPACE_LIMIT
> based on whether CONFIG_PCI is enabled or not.
> 

Yes, correct.

	Arnd
