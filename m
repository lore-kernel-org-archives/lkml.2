Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389Ab1AWCik (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 21:38:40 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:36620 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab1AWCih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 21:38:37 -0500
Subject: Re: [PATCH 0/7] Nexus One Support
From: David Woodhouse <dwmw2@infradead.org>
To: Brian Swetland <swetland@google.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Pekka Enberg <penberg@kernel.org>,
        Daniel Walker <dwalker@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Dima Zavin <dmitriyz@google.com>, Joe Perches <joe@perches.com>,
        davidb@codeaurora.org, linux-arm-kernel@lists.infradead.org
In-Reply-To: <AANLkTi=47z21zExtfHq2WYdUdXeC1rNhe7vQsqPkFsMi@mail.gmail.com>
References: <20110121094827.41818a55@jbarnes-desktop>
	 <20110121095658.1ab623fe@jbarnes-desktop>
	 <1295632828.19880.22.camel@m0nster>
	 <20110121100441.06a94482@jbarnes-desktop>
	 <1295633882.19880.31.camel@m0nster>
	 <AANLkTi=L+MW5-KLP_TKSxhstD8JEtBW=RKci5wSbZsd6@mail.gmail.com>
	 <1295642995.19880.42.camel@m0nster> <1295643762.25868.31.camel@Joe-Laptop>
	 <1295645098.22882.1.camel@m0nster>
	 <AANLkTi=mvdfpCPefGeDr+eGxpSUr3is5jgugHtgB-m1w@mail.gmail.com>
	 <20110122122018.GC5194@n2100.arm.linux.org.uk>
	 <AANLkTi=47z21zExtfHq2WYdUdXeC1rNhe7vQsqPkFsMi@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 23 Jan 2011 12:38:17 +1000
Message-ID: <1295750297.2980.47.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-01-22 at 11:22 -0800, Brian Swetland wrote:
> 
> What would be useful would be a reasonable convention for
> acknowledging multiple authors, perhaps something along the lines of:
> 
> Author: Awesome Upstreamer <au@example.com>  or  Main Author <main@example.com>
> Committer: Awesome Upstreamer <au@example.com>
> Subject: arm: msm8k: acpu clock management
> 
> ... summary of the patch ...
> 
> Original-Author: Joe Firmware Guy <joe@oem.com>
> Original-Author: Kernel Droid <droid@android.com>
> Signed-off-by: ... 

Nah, sod that. If the original authors couldn't be bothered to do their
work properly in the first place so that it was upstreamable, then as
far as I'm concerned they don't deserve the credit.

We should do the bare minimum that's required by copyright law, which is
making sure that the code is permitted in the kernel under the GPL.

Since the GPL doesn't have, and doesn't *allow*, a clause like the BSD
advertising clause, we have no requirement to credit the original
authors.

If they wanted credit, they should have done the job right in the first
place. Or at least finished the job for themselves rather than forcing
someone else to clean up their mess.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

