Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148Ab2F0G0f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 02:26:35 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:59930 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab2F0G0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 02:26:34 -0400
X-AuditID: 9c930179-b7cceae000004195-dc-4feaa7986792
Message-ID: <4FEAA7A1.9020307@kernel.org>
Date: Wed, 27 Jun 2012 15:26:41 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.mm,gmane.linux.kernel
To: Alex Shi <alex.shi@intel.com>
CC: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>
Subject: Re: [PATCH 3/3] x86: add local_tlb_flush_kernel_range()
References: <1340640878-27536-1-git-send-email-sjenning@linux.vnet.ibm.com> <1340640878-27536-4-git-send-email-sjenning@linux.vnet.ibm.com> <4FEA9FDD.6030102@kernel.org> <4FEAA4AA.3000406@intel.com>
In-Reply-To: <4FEAA4AA.3000406@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 06/27/2012 03:14 PM, Alex Shi wrote:

> On 06/27/2012 01:53 PM, Minchan Kim wrote:
> 
>> On 06/26/2012 01:14 AM, Seth Jennings wrote:
>>
>>> This patch adds support for a local_tlb_flush_kernel_range()
>>> function for the x86 arch.  This function allows for CPU-local
>>> TLB flushing, potentially using invlpg for single entry flushing,
>>> using an arch independent function name.
>>>
>>> Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
>>
>>
>> Anyway, we don't matter INVLPG_BREAK_EVEN_PAGES's optimization point is 8 or something.
> 
> 
> Different CPU type has different balance point on the invlpg replacing
> flush all. and some CPU never get benefit from invlpg, So, it's better
> to use different value for different CPU, not a fixed
> INVLPG_BREAK_EVEN_PAGES.


I think it could be another patch as further step and someone who are
very familiar with architecture could do better than.
So I hope it could be merged if it doesn't have real big problem.

Thanks for the comment, Alex.


-- 
Kind regards,
Minchan Kim
