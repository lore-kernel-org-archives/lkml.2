Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932642Ab2HHP1K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 11:27:10 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:59654 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932309Ab2HHP1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 11:27:07 -0400
Date: Wed, 8 Aug 2012 08:26:57 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: linux-kernel@vger.kernel.org, benh@kernel.crashing.org, arnd@arndb.de,
        rmk@arm.linux.org.uk, broonie@opensource.wolfsonmicro.com,
        stable@vger.kernel.org, sameo@linux.intel.com, rpurdie@rpsys.net,
        bryan.wu@canonical.com
Subject: Re: [PATCH 1/3] mfd: 88pm860x: use REG resource for backlight
Message-ID: <20120808152657.GA15916@kroah.com>
References: <1344364969-32489-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1344439048-26630-1-git-send-email-haojian.zhuang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344439048-26630-1-git-send-email-haojian.zhuang@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2012 at 11:17:26PM +0800, Haojian Zhuang wrote:
> Now resource of 88pm860x backlight is changed from IORESOURCE_IO
> to IORESOURCE_REG. In original driver, the resource is using
> self-defined IORESOURCE_IO. So change the resource to register
> offset to match the definition of IORESOURCE_REG.
> 
> Signed-off-by: Haojian Zhuang <haojian.zhuang@gmail.com>
> ---
>  drivers/mfd/88pm860x-core.c           |   78 ++++++++++++----------
>  drivers/video/backlight/88pm860x_bl.c |  114 +++++++++++++--------------------
>  include/linux/mfd/88pm860x.h          |    8 ---
>  3 files changed, 89 insertions(+), 111 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
