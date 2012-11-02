Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761175Ab2KBBX0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 21:23:26 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:17575 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756165Ab2KBBXX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 21:23:23 -0400
X-IronPort-AV: E=Sophos;i="4.80,696,1344182400"; 
   d="scan'208";a="6119851"
Message-ID: <5093202E.4050700@cn.fujitsu.com>
Date: Fri, 02 Nov 2012 09:21:50 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>
CC: yinghai@kernel.org, bhelgaas@google.com, lenb@kernel.org,
        jiang.liu@huawei.com, izumi.taku@jp.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/3] Improve container_notify_cb() to support container
 hot-remove.
References: <1351668471-31436-1-git-send-email-tangchen@cn.fujitsu.com>  <1351668471-31436-4-git-send-email-tangchen@cn.fujitsu.com> <1351788194.19172.98.camel@misato.fc.hp.com>
In-Reply-To: <1351788194.19172.98.camel@misato.fc.hp.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/02 09:22:15,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/02 09:22:16,
	Serialize complete at 2012/11/02 09:22:16
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/02/2012 12:43 AM, Toshi Kani wrote:
>
> Hi Tang,
>
> Rafael pointed out in my CPU hot-remove patch that
> acpi_bus_hot_remove_device() was not exported for modules.  Looks like
> you have the same problem here.  FYI, I just sent the following patch
> that exports acpi_bus_hot_remove_device() and acpi_os_hotplug_execute().
>
> https://lkml.org/lkml/2012/11/1/225
>
Hi Toshi,

I see. Thanks for the info. :)

Thanks.

