Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932915Ab2KWHLz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 02:11:55 -0500
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:49151 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932743Ab2KWHLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 02:11:54 -0500
Message-ID: <50AF2204.4070508@marvell.com>
Date: Fri, 23 Nov 2012 15:13:08 +0800
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
Subject: Re: [PATCH 1/7] mfd: max8925: add irqdomain for dt
References: <1352187429-9711-1-git-send-email-qingx@marvell.com>
In-Reply-To: <1352187429-9711-1-git-send-email-qingx@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Nov 2012 07:11:45.0422 (UTC) FILETIME=[CBE572E0:01CDC949]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2012 03:37 PM, Qing Xu wrote:
> From: Qing Xu <qingx@marvell.com>
>
> Add irqdomains for max8925's main irq, and touch irq.
> Wrap irq register operations into irqdomain's map func.
> it is necessary for dt support.
> Also, add dt support for max8925 driver.
>
> Signed-off-by: Qing Xu <qingx@marvell.com>
> ---
>   drivers/mfd/max8925-core.c  |   87 ++++++++++++++++++++++++++++---------------
>   drivers/mfd/max8925-i2c.c   |   32 +++++++++++++++-
>   include/linux/mfd/max8925.h |   12 ++++-
>   3 files changed, 96 insertions(+), 35 deletions(-)
>
> diff --git a/drivers/mfd/max8925-core.c b/drivers/mfd/max8925-core.c
> index 1e0ab0a..dcc218a 100644
> --- a/drivers/mfd/max8925-core.c
> +++ b/drivers/mfd/max8925-core.c
> @@ -14,10 +14,14 @@
>   #include <linux/i2c.h>
>   #include <linux/irq.h>
>   #include <linux/interrupt.h>
> +#include <linux/irqdomain.h>
>   #include <linux/platform_device.h>
>   #include <linux/regulator/machine.h>
>   #include <linux/mfd/core.h>
>   #include <linux/mfd/max8925.h>
> +#include <linux/of.h>
> +#include <linux/of_platform.h>
> +#include <linux/of_irq.h>
Hi Haojian, Sameo,

Could you help to review my patches? Can it be merged?

Thanks a lot!
-Qing

