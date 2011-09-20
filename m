Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421Ab1ITPJd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 11:09:33 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:63817 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751Ab1ITPJb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 11:09:31 -0400
Date: Tue, 20 Sep 2011 17:09:26 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Deepthy Ravi <deepthy.ravi@ti.com>
cc: laurent.pinchart@ideasonboard.com, mchehab@infradead.org, tony@atomide.com,
        hvaibhav@ti.com, linux-media@vger.kernel.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, kyungmin.park@samsung.com,
        hverkuil@xs4all.nl, m.szyprowski@samsung.com, santosh.shilimkar@ti.com,
        khilman@deeprootsystems.com, david.woodhouse@intel.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH 2/5] [media] v4l: Add mt9t111 sensor driver
In-Reply-To: <1316530612-23075-3-git-send-email-deepthy.ravi@ti.com>
Message-ID: <Pine.LNX.4.64.1109201704190.11274@axis700.grange>
References: <1316530612-23075-1-git-send-email-deepthy.ravi@ti.com>
 <1316530612-23075-3-git-send-email-deepthy.ravi@ti.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V02:K0:NMYlcClf/+ymEufLPCH7Pdhd7VQl8qQuLPkoFlYLkJR
 iasMgY4IZsO0M2GcTAOg144Z2+6tg6krSEB/6Y+07yqkGSu5V9
 LKzPIcXjYJdSBXkdbKam6Y2fQp/CDA48diF+rN/srLvmIWyOO9
 O/niEAoJSA/aZJzyV+i0FR/77mbaPRLfntuSGQp4lnaC5A4xe8
 O7CqjnuMfotFa22caKRPujuNuUU6bLT9bN03+Wkfc+LlABd706
 NIjnXcn98RWjkVA+ooNi4mDydZVKqctHF5QmYUn1rQ8indPOBb
 Zffef5Y7icLNgFLIAosOMnyC7AgzllqmUdUTcYwsqeA0/8YGxS
 7P3xb6bKVFUT7TarBOoTYXLtT0jpqTrktKPaDlyp30iJGfA+CZ
 GhVkaTZVLp5AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Sep 2011, Deepthy Ravi wrote:

> From: Vaibhav Hiremath <hvaibhav@ti.com>
> 
> The MT9T111 is a 3.1Mp CMOS sensor from Aptina with
> its latest image signal processing (ISP) and 1.75μm
> pixel technology.
> The sensor driver currently supports only VGA
> resolution.
> 
> Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
> Signed-off-by: Deepthy Ravi <deepthy.ravi@ti.com>
> ---
>  drivers/media/video/Kconfig       |    7 +
>  drivers/media/video/Makefile      |    1 +
>  drivers/media/video/mt9t111.c     |  793 +++++++++++++++++++++
>  drivers/media/video/mt9t111_reg.h | 1367 +++++++++++++++++++++++++++++++++++++
>  include/media/mt9t111.h           |   45 ++
>  5 files changed, 2213 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/video/mt9t111.c
>  create mode 100644 drivers/media/video/mt9t111_reg.h
>  create mode 100644 include/media/mt9t111.h

NAK. The mt9t112 driver claims to also support mt9t111. I'm not sure, 
whether the driver has indeed been tested with mt9t111, but this is 
definitely something to verify. If the chips are indeed similar, please 
use the tree at

http://git.linuxtv.org/gliakhovetski/v4l-dvb.git/shortlog/refs/heads/rc1-for-3.2

which has converted the mt9t112 driver to be also used outside ot the 
soc-camera subsystem, and use that driver instead of adding another one.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
