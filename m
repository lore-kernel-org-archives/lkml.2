Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758074Ab2FGWnG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 18:43:06 -0400
Received: from mga03.intel.com ([143.182.124.21]:35350 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751931Ab2FGWnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 18:43:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="153162365"
Date: Thu, 7 Jun 2012 15:43:03 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, mingo@elte.hu
Subject: Re: [PATCH 1/2] perf, x86: Add basic Ivy Bridge support
Message-ID: <20120607224303.GN28225@tassilo.jf.intel.com>
References: <1339108157-30021-1-git-send-email-andi@firstfloor.org>
 <CABPqkBSEknXdTQWCrxeeeFgREX02ARRzxJ8bj6uh+0yOi0nAjg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBSEknXdTQWCrxeeeFgREX02ARRzxJ8bj6uh+0yOi0nAjg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But as far as I know for the other generic stall event:
>                /* UOPS_DISPATCHED.THREAD,c=1,i=1 to count stall cycles*/
>                 intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_BACKEND] =
>                         X86_CONFIG(.event=0xb1, .umask=0x01, .inv=1, .cmask=1);

Okay.  I'll just undefine it.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only
