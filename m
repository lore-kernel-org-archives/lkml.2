Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932892Ab2KWHLd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 02:11:33 -0500
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:52535 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932743Ab2KWHLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 02:11:31 -0500
Message-ID: <50AF21ED.4090103@marvell.com>
Date: Fri, 23 Nov 2012 15:12:45 +0800
From: Qing Xu <qingx@marvell.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Qing Xu <qingx@marvell.com>
Cc: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "haojian.zhuang@gmail.com" <haojian.zhuang@gmail.com>,
        Chao Xie <cxie4@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH 0/7] mfd: update on max8925 for DT support
References: <1352187305-9660-1-git-send-email-qingx@marvell.com>
In-Reply-To: <1352187305-9660-1-git-send-email-qingx@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Nov 2012 07:11:21.0828 (UTC) FILETIME=[BDD54A40:01CDC949]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2012 03:35 PM, Qing Xu wrote:
> From: Qing Xu <qingx@marvell.com>
>
> 1. add irqdomain for max8925, it is necessary for dt support
> 2. bug fix in max8925 mfd devices'irq base and device registry failure
> 3. support DT for max8925 mfd devices
>
> Qing Xu (7):
>    mfd: max8925: add irqdomain for dt
>    mfd: max8925: fix mfd device register failure
>    mfd: max8925: fix onkey driver irq base
>    mfd: max8925: support dt for power supply
>    mfd: max8925: support dt for regulator
>    mfd: max8925: support dt for backlight
>    mfd: max8925: add dts
>
>   arch/arm/boot/dts/mmp2-brownstone.dts |  166 +++++++++++++++++++++++++++++++++
>   arch/arm/boot/dts/mmp2.dtsi           |    4 +-
>   drivers/input/misc/max8925_onkey.c    |    3 -
>   drivers/mfd/max8925-core.c            |  107 +++++++++++++--------
>   drivers/mfd/max8925-i2c.c             |   32 ++++++-
>   drivers/power/max8925_power.c         |   57 ++++++++++-
>   drivers/regulator/max8925-regulator.c |   35 +++++++-
>   drivers/video/backlight/max8925_bl.c  |   31 ++++++-
>   include/linux/mfd/max8925.h           |   12 ++-
>   9 files changed, 389 insertions(+), 58 deletions(-)
>
Hi Haojian, Sameo,

Could you help to review my patches? Can it be merged?

Thanks a lot!
-Qing
