Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933169Ab0J0Olu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 10:41:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54932 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754994Ab0J0Olt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 10:41:49 -0400
Message-ID: <4CC83A10.8090607@zytor.com>
Date: Wed, 27 Oct 2010 07:41:20 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Andres Salomon <dilinger@queued.net>, devicetree-discuss@lists.ozlabs.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: OLPC: add OLPC device-tree support (v3)
References: <20101022155846.66cde32f@queued.net> <20101027101933.GD6797@angua.secretlab.ca>
In-Reply-To: <20101027101933.GD6797@angua.secretlab.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2010 03:19 AM, Grant Likely wrote:
> On Fri, Oct 22, 2010 at 03:58:46PM -0700, Andres Salomon wrote:
>>
>> Make use of PROC_DEVICETREE to export the tree, and sparc's PROMTREE code to
>> call into OLPC's Open Firmware to build the tree.
>>
>> v3: rename olpc_prom to olpc_dt
>>   - rework Kconfig entries
>>   - drop devtree build hook from proc, instead adding a call to x86's
>>     paging_init (similarly to how sparc64 does it)
>>   - switch allocation from using slab to alloc_bootmem.  this allows
>>     the DT to be built earlier during boot (during setup_arch); the
>>     downside is that there are some 1200 bootmem reservations that are
>>     done during boot.  Not ideal..
>>   - add a helper olpc_ofw_is_installed function to test for the
>>     existence and successful detection of OLPC's OFW.
>>
>> Signed-off-by: Andres Salomon <dilinger@queued.net>
> 
> Overall this patch looks fine, but it needs to be acked from the x86
> maintainers, and I'd like it to have a cycle through linux-next before
> it gets merged, so that means 2.6.38 because the 2.6.37 merge window
> has already been open for almost a week.
> 

Right... which means that our attention is going to be elsewhere for a
bit -- probably until after KS/LPC.  Sorry, just immediate
prioritization and nothing to do with the relative importance.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

