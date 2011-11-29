Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813Ab1K2VbO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 16:31:14 -0500
Received: from mga01.intel.com ([192.55.52.88]:17362 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756377Ab1K2VbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 16:31:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,593,1315206000"; 
   d="scan'208";a="90327981"
From: Andi Kleen <andi@firstfloor.org>
To: Hans Rosenfeld <hans.rosenfeld@amd.com>
Cc: <hpa@zytor.com>, <tglx@linutronix.de>, <mingo@elte.hu>,
        <suresh.b.siddha@intel.com>, <eranian@google.com>, <brgerst@gmail.com>,
        <robert.richter@amd.com>, <Andreas.Herrmann3@amd.com>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/9] rework of extended state handling, LWP support
References: <1322570488-21798-1-git-send-email-hans.rosenfeld@amd.com>
Date: Tue, 29 Nov 2011 13:31:09 -0800
In-Reply-To: <1322570488-21798-1-git-send-email-hans.rosenfeld@amd.com> (Hans
	Rosenfeld's message of "Tue, 29 Nov 2011 13:41:19 +0100")
Message-ID: <m2ipm2lioy.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hans Rosenfeld <hans.rosenfeld@amd.com> writes:
>
> The lazy allocation of the xstate area has been removed. The support for
> extended states that cannot be saved/restored lazily, like AMD's LWP,
> need this. Since optimized library functions using SSE etc. are widely
> used today, most processes would have an xstate area anyway, making the
> memory overhead negligible.

Do you have any data on that?  It sounds dubious for specialized
workloads.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
