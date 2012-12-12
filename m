Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187Ab2LLXzK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 18:55:10 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59313 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462Ab2LLXzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 18:55:08 -0500
Date: Wed, 12 Dec 2012 15:55:04 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Toshi Kani <toshi.kani@hp.com>
Cc: rjw@sisk.pl, lenb@kernel.org, akpm@linux-foundation.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, bhelgaas@google.com,
        isimatu.yasuaki@jp.fujitsu.com, jiang.liu@huawei.com,
        wency@cn.fujitsu.com, guohanjun@huawei.com, yinghai@kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com
Subject: Re: [RFC PATCH 02/11] drivers/base: Add hotplug framework code
Message-ID: <20121212235504.GC22764@kroah.com>
References: <1355354243-18657-1-git-send-email-toshi.kani@hp.com>
 <1355354243-18657-3-git-send-email-toshi.kani@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355354243-18657-3-git-send-email-toshi.kani@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2012 at 04:17:14PM -0700, Toshi Kani wrote:
> --- a/drivers/base/Makefile
> +++ b/drivers/base/Makefile
> @@ -21,6 +21,7 @@ endif
>  obj-$(CONFIG_SYS_HYPERVISOR) += hypervisor.o
>  obj-$(CONFIG_REGMAP)	+= regmap/
>  obj-$(CONFIG_SOC_BUS) += soc.o
> +obj-$(CONFIG_HOTPLUG)	+= hotplug.o

CONFIG_HOTPLUG just got always enabled in the kernel, and I'm about to
delete it around the 3.8-rc2 timeframe, so please don't add new usages
of it to the kernel.

greg k-h
