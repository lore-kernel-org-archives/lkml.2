Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714Ab1E3GtK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 02:49:10 -0400
Received: from mga09.intel.com ([134.134.136.24]:41869 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753208Ab1E3GtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 02:49:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,290,1304319600"; 
   d="scan'208";a="6650072"
Message-ID: <4DE33DDB.2050304@linux.intel.com>
Date: Mon, 30 May 2011 14:48:59 +0800
From: Chen Gong <gong.chen@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; zh-CN; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/9] ACPI, APEI patches for 2.6.40
References: <1305619719-7480-1-git-send-email-ying.huang@intel.com> <alpine.LFD.2.02.1105290252150.7577@arrandale.kernel.org>
In-Reply-To: <alpine.LFD.2.02.1105290252150.7577@arrandale.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 5/29/2011 2:55 PM, Len Brown 写道:
>> [PATCH 1/9] Add Kconfig option ARCH_HAVE_NMI_SAFE_CMPXCHG
>> [PATCH 2/9] lib, Add lock-less NULL terminated single list
>> [PATCH 3/9] lib, Make gen_pool memory allocator lockless
>> [PATCH 4/9] ACPI, APEI, GHES, printk support for recoverable error via NMI
>
> I think the 4 above should go upstream to enable the
> printk for recoverable errors.  If queuing messages
> from NMI context gets re-implemented in the future,
> then so be it.
>
> I'll skip the rest, however, except #9:-)
>
> thanks,
> -Len
>
>> [PATCH 5/9] HWPoison: add memory_failure_queue()
>> [PATCH 6/9] ACPI, APEI, GHES: Add hardware memory error recovery support
>> [PATCH 7/9] PCIe, AER, add aer_recover_queue
>> [PATCH 8/9] ACPI, APEI, GHES: Add PCIe AER recovery support
>> [PATCH 9/9] ACPI, APEI, ERST, Prevent erst_dbg from loading if ERST is disabled
>>
> --

Hi, Len

Would you please help to review and merge my patch to fix an issue for 
ERST debug module ? Here is the link:
https://patchwork.kernel.org/patch/802662/

