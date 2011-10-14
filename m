Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212Ab1JNR6i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 13:58:38 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60806 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282Ab1JNR6g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 13:58:36 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:1aa9:5ff:fe24:37a9]
In-Reply-To: <alpine.LFD.2.02.1110141348270.17040@xanadu.home>
References: <1317172068-14872-1-git-send-email-pdeschrijver@nvidia.com>
	<20111014071500.GP21648@n2100.arm.linux.org.uk>
	<74CDBE0F657A3D45AFBB94109FB122FF173BE1A260@HQMAIL01.nvidia.com>
	<201110141729.41515.arnd@arndb.de>
	<74CDBE0F657A3D45AFBB94109FB122FF173BE1A283@HQMAIL01.nvidia.com>
	<alpine.LFD.2.02.1110141348270.17040@xanadu.home>
Date: Fri, 14 Oct 2011 10:58:35 -0700
Message-ID: <CAOesGMhm_dD=9dyMWQRfH5AXH4AE42+4ckNwhnMUGaBJEHsumg@mail.gmail.com>
Subject: Re: [PATCH] arm/tegra: select AUTO_ZRELADDR by default
From: Olof Johansson <olof@lixom.net>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Stephen Warren <swarren@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "Colin Cross (ccross@android.com)" <ccross@android.com>,
        Erik Gilling <konkers@android.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Oct 14, 2011 at 10:53 AM, Nicolas Pitre <nico@fluxnic.net> wrote:

> As I explained yesterday, I'm working on more cleanups that involve
> reworking the dependencies around ZBOOTROM, AUTO_ZRELADDR and friends,
> and removing zreladdr for all platforms.  So please do not come up with
> Tegra specific hacks to fix this up.  So for the time being I'd simply
> suggest using the minimal fix i.e.:
>
>        select AUTO_ZRELADDR if !ZBOOT_ROM
>
> And eventually this will disappear entirely in favor of a single global
> config option which is not platform dependent.

Odd, I'm not seeing any mention of the above on the list (especially
not posted yesterday), but that sounds good to me.

We've dropped the patch for now, if t30 needs it we can update the
defconfig when the time comes, and wait for your cleanup for the rest.


-Olof
