Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932476Ab2CBWac (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 17:30:32 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:11851 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932193Ab2CBWaa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 17:30:30 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 02 Mar 2012 14:30:15 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Alan Ott <alan@signal11.us>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>, Russell King <linux@arm.linux.org.uk>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 2 Mar 2012 14:30:14 -0800
Subject: RE: [PATCH v3 0/5] ARM: Tegra: cleanup patches from Arnd Bergmann
Thread-Topic: [PATCH v3 0/5] ARM: Tegra: cleanup patches from Arnd Bergmann
Thread-Index: Acz4w0X0QiqxAp6EQeOr1PUzmM9FlQAAKakw
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF17BE861AAB@HQMAIL01.nvidia.com>
References: <1330721884-8495-1-git-send-email-alan@signal11.us>
 <1330727075-10974-1-git-send-email-alan@signal11.us>
In-Reply-To: <1330727075-10974-1-git-send-email-alan@signal11.us>
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

Alan Ott wrote at Friday, March 02, 2012 3:25 PM:
> Version 3 of the patch set.
> 
> Changes:
> 	* change of logic (and commit message change) for
> 	  "select USB_ULPI if USB is selected"
> 	* dropped THUMB2 patch
> 
> Arnd Bergmann (5):
>   ARM: tegra: do not hide dma declarations
>   ARM: tegra: select CPU_FREQ_TABLE
>   ARM: tegra: build localtimer support only when needed
>   ARM: tegra: select USB_ULPI if USB is selected
>   ARM: tegra: export usb phy symbols

The series,

Acked-by: Stephen Warren <swarren@nvidia.com>

Thanks Arnd and Alan for cleaning Tegra up!

-- 
nvpublic

