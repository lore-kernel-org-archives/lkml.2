Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932363Ab2INAY4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 20:24:56 -0400
Received: from mga01.intel.com ([192.55.52.88]:61199 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753340Ab2INAYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 20:24:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,420,1344236400"; 
   d="scan'208";a="221937136"
Message-ID: <5052792E.1010507@intel.com>
Date: Fri, 14 Sep 2012 08:24:14 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Cliff Wickman <cpw@sgi.com>
CC: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        jbeulich@suse.com, tglx@linutronix.de, hpa@zytor.com
Subject: Re: [alex.shi@intel.com: Re: [PATCH] UV: fix incorrect tlb flush
 all issue]
References: <20120913155310.GA4081@gmail.com> <20120913212003.GA16789@sgi.com>
In-Reply-To: <20120913212003.GA16789@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14/2012 05:20 AM, Cliff Wickman wrote:

> On Thu, Sep 13, 2012 at 05:53:10PM +0200, Ingo Molnar wrote:
>>
>> Ack?
>>
>> Thanks,
>>
>> 	Ingo
> 
> Ack.
> But with the adjustment below.  The 'end' argument was not declared long.
> 
> I tested the patch on a UV.
> It has the effect of either clearing 1 or all TLBs in a cpu.
> I added some debugging to test for the cases when clearing all TLBs is
> overkill, and in practice it happens very seldom.


Thanks a lot for you all!

> 
> Sorry I didn't participate in this patch earlier.  Jack Steiner was
> copied, I believe.  But steiner@sgi.com is no longer active. Jack has
> retired -- congratulations to him, but a very big loss to us, both 
> professionally and personally.


Congratulations for Jack. :)

