Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767Ab2IXBin (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 21:38:43 -0400
Received: from mga01.intel.com ([192.55.52.88]:5545 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754729Ab2IXBim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 21:38:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,471,1344236400"; 
   d="scan'208";a="225772376"
Message-ID: <505FB96E.8050608@intel.com>
Date: Mon, 24 Sep 2012 09:37:50 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
CC: x86@kernel.org, yrl.pp-manager.tt@hitachi.com,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: Distinguish TLB shootdown interrupts from other
 functions call interrupts
References: <505A6EFD.4070802@intel.com> <20120920085033.14512.98190.stgit@hpxw>
In-Reply-To: <20120920085033.14512.98190.stgit@hpxw>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2012 04:50 PM, Tomoki Sekiyama wrote:

>  	unsigned int irq_resched_count;
>  	unsigned int irq_call_count;
> +	/* irq_tlb_count is double-counted in irq_call_count, so it must be
> +	   subtracted from irq_call_count when displaying irq_call_count */
>  	unsigned int irq_tlb_count;


Review again this patch, above comments is not kernel compatible format.
Could you change it like standard comment format:

/*
 * xxxxxxx
 * xxxx
 */

-- 
Thanks
    Alex
