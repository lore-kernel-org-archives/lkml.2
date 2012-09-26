Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745Ab2IZI21 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 04:28:27 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:35819 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457Ab2IZI2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 04:28:21 -0400
Message-ID: <5062BC7A.8020002@linux.vnet.ibm.com>
Date: Wed, 26 Sep 2012 13:57:38 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>
CC: "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yanmin_zhang@linux.intel.com" <yanmin_zhang@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] x86/fixup_irq: Clean the offlining CPU from the irq affinity
 mask
References: <1348669924.19514.6.camel@cliu38-desktop-build> <5062A442.2030207@linux.vnet.ibm.com> <27240C0AC20F114CBF8149A2696CBE4A189F97@SHSMSX101.ccr.corp.intel.com> <5062B602.6000502@linux.vnet.ibm.com> <27240C0AC20F114CBF8149A2696CBE4A18A2E4@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4A18A2E4@SHSMSX101.ccr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12092608-5140-0000-0000-00000220BF60
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2012 01:47 PM, Liu, Chuansheng wrote:
>> Shouldn't we warn if that fails?
> printk("Cannot set affinity for irq %i\n", irq);
> This is the warning when set affinity failed.
> 

I know.. What I meant is, the code warns only if chip->irq_set_affinity
is NULL and doesn't care if chip->irq_set_affinity was not NULL and
the function failed to set the affinity (ie., when chip->irq_set_affinity()
returns error). In other words, I meant to say that this is one more
case where we need to warn about our failure to set the irq affinity. 
 
Regards,
Srivatsa S. Bhat

