Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253Ab2G3QhU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 12:37:20 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46820 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753932Ab2G3QhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 12:37:18 -0400
Date: Mon, 30 Jul 2012 17:37:02 +0100
From: Will Deacon <will.deacon@arm.com>
To: Chris Smith <chris.smith@st.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "srinidhi.kasagar@stericsson.com" <srinidhi.kasagar@stericsson.com>
Subject: Re: [PATCH 2/2] arm: pmu: add support for per-cpu PMU interrupts.
Message-ID: <20120730163701.GH15195@mudshark.cambridge.arm.com>
References: <1343658732-31080-1-git-send-email-chris.smith@st.com>
 <1343658732-31080-2-git-send-email-chris.smith@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343658732-31080-2-git-send-email-chris.smith@st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

On Mon, Jul 30, 2012 at 03:32:12PM +0100, Chris Smith wrote:
> We have systems where the PMU interrupts are PPIs, and so per-cpu. This
> patch adds support for per-cpu PMU interrupts to the perf event code.
> 
> Note that because the dev_id passed to request_percpu_irq has to be
> percpu data, we now pass cpu_hw_events as the dev_id rather than armpmu.
> This only place the dev_id was used was in armpmu_platform_irq, which is
> fixed up accordingly.
> 
> Signed-off-by: Chris Smith <chris.smith@st.com>
> ---

I'm actually in the process of moving request/free IRQ into an armpmu
callback, so this patch would fit more neatly into that.

I should have something available this week that you can take a look at.

Will
