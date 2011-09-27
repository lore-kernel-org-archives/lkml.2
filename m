Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394Ab1I0N5c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 09:57:32 -0400
Received: from hermes.mlbassoc.com ([64.234.241.98]:36133 "EHLO
	mail.chez-thomas.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753322Ab1I0N5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 09:57:31 -0400
X-Greylist: delayed 370 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Sep 2011 09:57:31 EDT
Message-ID: <4E81D4D6.2000000@mlbassoc.com>
Date: Tue, 27 Sep 2011 07:51:18 -0600
From: Gary Thomas <gary@mlbassoc.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Deepthy Ravi <deepthy.ravi@ti.com>
CC: laurent.pinchart@ideasonboard.com, mchehab@infradead.org, tony@atomide.com,
        hvaibhav@ti.com, linux-media@vger.kernel.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, kyungmin.park@samsung.com,
        hverkuil@xs4all.nl, m.szyprowski@samsung.com, g.liakhovetski@gmx.de,
        santosh.shilimkar@ti.com, khilman@deeprootsystems.com,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH v2 0/5] OMAP3EVM: Add support for MT9T111 sensor
References: <1317130848-21136-1-git-send-email-deepthy.ravi@ti.com>
In-Reply-To: <1317130848-21136-1-git-send-email-deepthy.ravi@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-09-27 07:40, Deepthy Ravi wrote:
> This patchset
> 	-adds support for MT9T111 sensor on omap3evm.
> 	Currently the sensor driver supports only
> 	VGA resolution.
> 	-enables MT9T111 sensor in omap2plus_defconfig.
>
> This is dependent on the following patchset
> http://www.spinics.net/lists/linux-media/msg37270.html
> which adds YUYV input support for OMAP3ISP. And is
> applied on top of rc1-for-3.2 of gliakhovetski/v4l-dvb.git

Why not use the same base as Lennart?
   The set is based on
   http://git.linuxtv.org/pinchartl/media.git/shortlog/refs/heads/omap3isp-omap3isp-next

> ---
> Changes in v2:
> 	As per the discussion here,
> 	https://lkml.org/lkml/2011/9/20/280
> 	the existing mt9t112 driver is reused for
> 	adding support for mt9t111 sensor.
> Deepthy Ravi (3):
>    [media] v4l: Add support for mt9t111 sensor driver
>    ispccdc: Configure CCDC_SYN_MODE register
>    omap2plus_defconfig: Enable omap3isp and MT9T111 sensor drivers
>
> Vaibhav Hiremath (2):
>    omap3evm: Enable regulators for camera interface
>    omap3evm: Add Camera board init/hookup file
>
>   arch/arm/configs/omap2plus_defconfig        |    9 +
>   arch/arm/mach-omap2/Makefile                |    5 +
>   arch/arm/mach-omap2/board-omap3evm-camera.c |  185 ++++
>   arch/arm/mach-omap2/board-omap3evm.c        |   26 +
>   drivers/media/video/Kconfig                 |    7 +
>   drivers/media/video/Makefile                |    1 +
>   drivers/media/video/mt9t111_reg.h           | 1367 +++++++++++++++++++++++++++
>   drivers/media/video/mt9t112.c               |  320 ++++++-
>   drivers/media/video/omap3isp/ispccdc.c      |   11 +-
>   include/media/mt9t111.h                     |   45 +
>   10 files changed, 1937 insertions(+), 39 deletions(-)
>   create mode 100644 arch/arm/mach-omap2/board-omap3evm-camera.c
>   create mode 100644 drivers/media/video/mt9t111_reg.h
>   create mode 100644 include/media/mt9t111.h

-- 
------------------------------------------------------------
Gary Thomas                 |  Consulting for the
MLB Associates              |    Embedded world
------------------------------------------------------------
