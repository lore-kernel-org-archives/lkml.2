Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505Ab2KAGIm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 02:08:42 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:37908 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751312Ab2KAGIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 02:08:40 -0400
X-IronPort-AV: E=Sophos;i="4.80,692,1344182400"; 
   d="scan'208";a="6114323"
Message-ID: <5092119F.1000600@cn.fujitsu.com>
Date: Thu, 01 Nov 2012 14:07:27 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: bhelgaas@google.com, lenb@kernel.org, jiang.liu@huawei.com,
        izumi.taku@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] Use acpi_os_hotplug_execute() instead of alloc_acpi_hp_work().
References: <1351668471-31436-1-git-send-email-tangchen@cn.fujitsu.com> <1351668471-31436-2-git-send-email-tangchen@cn.fujitsu.com> <CAE9FiQWZ=Xgnw-U=4v2a5W7OwBkA3gT63qDnNYGT9p8Rn0O3fg@mail.gmail.com>
In-Reply-To: <CAE9FiQWZ=Xgnw-U=4v2a5W7OwBkA3gT63qDnNYGT9p8Rn0O3fg@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/01 14:07:53,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/01 14:07:54,
	Serialize complete at 2012/11/01 14:07:54
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2012 11:52 AM, Yinghai Lu wrote:
> On Wed, Oct 31, 2012 at 12:27 AM, Tang Chen<tangchen@cn.fujitsu.com>  wrote:
> Please check if you can just fold
>     acpi_hp_cb_execute
> callers, and use acpi_os_hotplug_execute directly.
>
> and have two local conext struct too.
>
I think this could bring some duplicated work. We need to do the same
work every time we call acpi_os_hotplug_execute(), what has been done
in acpi_hp_cb_execute().

I can try to modify it and resend a new patch to see if it is better.

Thanks. :)



