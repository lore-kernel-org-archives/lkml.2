Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538Ab2FMWeP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 18:34:15 -0400
Received: from mga01.intel.com ([192.55.52.88]:21051 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732Ab2FMWeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 18:34:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="165345161"
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, eranian@google.com
Subject: Re: [PATCH 3/4] perf, x86: check ucode before disabling PEBS on SandyBridge v3
References: <1339618842-26636-1-git-send-email-andi@firstfloor.org>
	<1339618842-26636-4-git-send-email-andi@firstfloor.org>
	<1339623054.8980.64.camel@twins>
	<20120613213451.GC32604@tassilo.jf.intel.com>
	<1339623417.8980.68.camel@twins>
Date: Wed, 13 Jun 2012 15:34:13 -0700
In-Reply-To: <1339623417.8980.68.camel@twins> (Peter Zijlstra's message of
	"Wed, 13 Jun 2012 23:36:57 +0200")
Message-ID: <m2k3zaj0yi.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:
>
> Is there a ucode revision for C2 higher than 0x618 but lower than
> 0x70c ? If so, your code is wrong for it would enable PEBS on that chip.

I was told there's only a single revision per model number that goes up.
That's also the model that other microcode checks in Linux follow.

Not sure what's happening with Stephane's setup.
I get 0x618 on Stepping 6. I'll try to find a C2.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
