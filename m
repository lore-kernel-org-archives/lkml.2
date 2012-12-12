Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246Ab2LLXyF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 18:54:05 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:62030 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755020Ab2LLXyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 18:54:03 -0500
Date: Wed, 12 Dec 2012 15:53:58 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Toshi Kani <toshi.kani@hp.com>
Cc: rjw@sisk.pl, lenb@kernel.org, akpm@linux-foundation.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, bhelgaas@google.com,
        isimatu.yasuaki@jp.fujitsu.com, jiang.liu@huawei.com,
        wency@cn.fujitsu.com, guohanjun@huawei.com, yinghai@kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com
Subject: Re: [RFC PATCH 01/11] Add hotplug.h for hotplug framework
Message-ID: <20121212235358.GA22764@kroah.com>
References: <1355354243-18657-1-git-send-email-toshi.kani@hp.com>
 <1355354243-18657-2-git-send-email-toshi.kani@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355354243-18657-2-git-send-email-toshi.kani@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2012 at 04:17:13PM -0700, Toshi Kani wrote:
> Added include/linux/hotplug.h, which defines the hotplug framework
> interfaces used by the framework itself and handlers.

No, please name this properly, _everything_ is hotpluggable these days,
and unless you want the whole kernel and all busses and devices to use
this, then it needs to be named much better than this, sorry.

We went through this same issue over 10 years ago, please, let's learn
from our mistakes and not do it again.

> +/* Add Validate order values */
> +#define HP_ACPI_BUS_ADD_VALIDATE_ORDER		0	/* must be first */

This is really ACPI specific, so why not just put it under include/acpi/
instead?

And note, PPC and other arches probably do this already (s390?) so to
exclude them from the beginning would not be a good idea.

greg k-h
