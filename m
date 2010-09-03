Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126Ab0ICNyC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 09:54:02 -0400
Received: from mga02.intel.com ([134.134.136.20]:36998 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405Ab0ICNyB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 09:54:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,313,1280732400"; 
   d="scan'208";a="653932517"
Message-ID: <4C80FDF7.1080106@linux.intel.com>
Date: Fri, 03 Sep 2010 06:53:59 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.11) Gecko/20100711 Thunderbird/3.0.6
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        "robert.richter" <robert.richter@amd.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.kernel.org>
Subject: Re: [PATCH] perf, x86: Disable perf if the BIOS got its grubby paws
 on the PMU
References: <1283505227.1783.224.camel@laptop>
In-Reply-To: <1283505227.1783.224.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/3/2010 2:13 AM, Peter Zijlstra wrote:
>
> +static void print_BIOS_fail(void)
> +{
> +	printk(KERN_ERR "\n");
> +	printk(KERN_ERR "=============================================\n");
> +	printk(KERN_ERR "It appears the BIOS is actively using the PMU\n");
> +	printk(KERN_ERR "this avoids Linux from using it, please de-  \n");
> +	printk(KERN_ERR "activate this BIOS feature or request a BIOS \n");
> +	printk(KERN_ERR "update from your vendor.                     \n");
> +	printk(KERN_ERR "=============================================\n");
> +
> +	memset(&x86_pmu, 0, sizeof(x86_pmu));
> +}
> +
>    


tell us how you really feel :-)

do you want to add a phone number of the support line of the vendor 
(based on DMI data of course) ?

