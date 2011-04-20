Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347Ab1DTJDM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 05:03:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:59224 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753019Ab1DTJDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 05:03:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,245,1301900400"; 
   d="scan'208";a="735944682"
Date: Wed, 20 Apr 2011 17:03:05 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC 1/4] HWPoison: add memory_failure_queue()
Message-ID: <20110420090305.GB3761@localhost>
References: <1303177419-22466-1-git-send-email-ying.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303177419-22466-1-git-send-email-ying.huang@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	if (kfifo_put(&mf_cpu->fifo, &entry))
> +		schedule_work_on(smp_processor_id(), &mf_cpu->work);
> +	else
> +		pr_err("Memory failure: buffer overflow when recovering memory failure at 0x%#lx\n",
> +		       pfn);

nitpick: "buffer overflow when recording memory failure at PFN ..."?

Thanks,
Fengguang
