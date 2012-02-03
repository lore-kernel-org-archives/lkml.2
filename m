Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033Ab2BCT7d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 14:59:33 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:12712 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755084Ab2BCT7b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 14:59:31 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Fri, 03 Feb 2012 11:59:30 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Simon Glass <sjg@chromium.org>, LKML <linux-kernel@vger.kernel.org>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>
Date: Fri, 3 Feb 2012 11:59:29 -0800
Subject: RE: [PATCH 0/3] arm: tegra: dts: USB Updates for Tegra legacy mode
 / OTG
Thread-Topic: [PATCH 0/3] arm: tegra: dts: USB Updates for Tegra legacy mode
 / OTG
Thread-Index: AczilMX/Xl6MvAEeSS2GGifQRvvj+AAGVSIg
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF178E5D2FF5@HQMAIL01.nvidia.com>
References: <1328288172-8059-1-git-send-email-sjg@chromium.org>
In-Reply-To: <1328288172-8059-1-git-send-email-sjg@chromium.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simon Glass wrote at riday, February 03, 2012 9:56 AM:
> This little series brings in some bindings that seem useful for U-Boot.
> 
> I am working mostly in U-Boot, but since there is no shared .dts repo
> I was asked to commit these changes to the kernel. I do not propose to
> update the Linux USB drivers to match.

I think the series looks reasonable, so:

Acked-by: Stephen Warren <swarren@nvidia.com<>

(I note that the kernel's USB driver for USB1 doesn't attempt to clear
legacy mode; I wonder how we're getting away with that. Perhaps it's
only been tested with a bootloader that's already cleared legacy mode)

-- 
nvpublic

