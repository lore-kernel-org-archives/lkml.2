Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400Ab1DUKF4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 06:05:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:39446 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750707Ab1DUKFz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 06:05:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,250,1301900400"; 
   d="scan'208";a="736442808"
Date: Thu, 21 Apr 2011 18:05:41 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC 1/4] HWPoison: add memory_failure_queue()
Message-ID: <20110421100541.GA991@localhost>
References: <1303177419-22466-1-git-send-email-ying.huang@intel.com>
 <20110420090305.GB3761@localhost>
 <4DAFD0F2.5080708@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DAFD0F2.5080708@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 02:38:42PM +0800, Huang, Ying wrote:
> Hi, Fengguang,
> 
> On 04/20/2011 05:03 PM, Wu, Fengguang wrote:
> >> +	if (kfifo_put(&mf_cpu->fifo, &entry))
> >> +		schedule_work_on(smp_processor_id(), &mf_cpu->work);
> >> +	else
> >> +		pr_err("Memory failure: buffer overflow when recovering memory failure at 0x%#lx\n",
> >> +		       pfn);
> > 
> > nitpick: "buffer overflow when recording memory failure at PFN ..."?
> 
> Yes, in fact we are not recovering now.  Or "s/recording/queuing/"?

OK, that's fine.

Thanks,
Fengguang
