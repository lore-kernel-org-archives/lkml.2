Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758065Ab2J0NMV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 09:12:21 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:51134 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753357Ab2J0NMP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 09:12:15 -0400
Message-ID: <508BDDA4.6050208@ti.com>
Date: Sat, 27 Oct 2012 18:42:04 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Constantine Shulyupin <const@MakeLinux.com>
CC: Tony Lindgren <tony@atomide.com>, <linux-kernel@vger.kernel.org>,
        <tim.bird@am.sony.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: OMAP4: Basic default configuration for Pandaboard
References: <1351339406-10082-1-git-send-email-const@MakeLinux.com>
In-Reply-To: <1351339406-10082-1-git-send-email-const@MakeLinux.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 27 October 2012 05:33 PM, Constantine Shulyupin wrote:
> From: Constantine Shulyupin <const@MakeLinux.com>
>
> Tested SD (MMC) and Ethernet smsc95xx on linux-3.7-rc2
>
> Signed-off-by: Constantine Shulyupin <const@MakeLinux.com>
> --
> kernel size is 2.3 MiB
> ---
>   arch/arm/configs/omap4_panda_defconfig |  115 ++++++++++++++++++++++++++++++++

We got rid of all omap board defconfigs and now just using
omap2plus_defconfig for all OMAP2/3/4/5 machines. If something
is missing from omap2plus_defconfig, which you need to on your
panda custom config, do send patch for that. Otherwise, we are
no longer adding board defconfigs.

Regards
Santosh
