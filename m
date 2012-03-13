Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758781Ab2CMCJR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 22:09:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:13788 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755341Ab2CMCJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 22:09:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="117092281"
Message-ID: <4F5EABFD.3090705@intel.com>
Date: Tue, 13 Mar 2012 10:07:57 +0800
From: ShuoX Liu <shuox.liu@intel.com>
Reply-To: shuox.liu@intel.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.27) Gecko/20120216 Thunderbird/3.1.19
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Valentin, Eduardo" <eduardo.valentin@ti.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        "Brown, Len" <len.brown@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] cpuidle: Move cpuidle sysfs entry of each cpu to
 debugfs.
References: <4F5466C4.2090808@intel.com> <20120305101827.GA19408@khazad-dum.debian.net> <CAGF5oy_BUytjeDa8Oc62pRabaEqwqKCFuVJuzLd-XNZg34ne2w@mail.gmail.com> <1330998885.1916.89.camel@ymzhang> <20120306052236.GA19416@kroah.com> <1331013078.1916.103.camel@ymzhang> <20120306143935.GA23346@kroah.com> <1331082051.1916.124.camel@ymzhang> <20120308180106.GD26516@kroah.com> <4F5DBFA8.3080300@intel.com> <20120312172258.GA29938@kroah.com>
In-Reply-To: <20120312172258.GA29938@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012年03月13日 01:22, Greg KH wrote:

> On Mon, Mar 12, 2012 at 05:19:36PM +0800, ShuoX Liu wrote:
>> I created a series to do this.
>>
>> [PATCH 1/3] cpuidle: Move cpuidle sysfs entry of each cpu to debugfs.
>> [PATCH 2/3] cpuidle: Add a debugfs entry to disable specific C state
>> for debug purpose.
>> [PATCH 3/3] cpupower: Update the cpupower tool for new debugfs
>> entries of cpuidle.
>>
>> Below are patches.
> 
> The patch is line-wrapped and can not be applied :(

Sorry that i made a mistake. I sent email with fresh email-client which
has the text-wrapping default. I will configure it.
I will send the patch in good format when needed.

>> --- /dev/null
>> +++ b/drivers/cpuidle/debugfs.c
>> @@ -0,0 +1,176 @@
>> +/*
>> + * debugfs.c - debugfs support
>> + *
>> + * (C) 2006-2007 Shaohua Li <shaohua.li@intel.com>
>> + * (C) 2012 ShuoX Liu <shuox.liu@intel.com>
>> + *
>> + * This code is licenced under the GPL.
> 
> What version of the GPL?

GPLv2

> 
> thanks,
> 
> greg k-h


thanks,
Shuo
