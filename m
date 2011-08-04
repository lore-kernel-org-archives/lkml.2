Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385Ab1HDXsK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 19:48:10 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40558 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753536Ab1HDXsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 19:48:07 -0400
Date: Fri, 5 Aug 2011 08:47:57 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sh@vger.kernel.org, Kevin Hilman <khilman@deeprootsystems.com>,
        Paul Mundt <lethal@linux-sh.org>, x86@kernel.org,
        Len Brown <len.brown@intel.com>
Subject: Re: [PATCH] cpuidle: Consistent spelling of cpuidle_idle_call()
Message-ID: <20110804234755.GA13321@opensource.wolfsonmicro.com>
References: <1312475071-22973-1-git-send-email-davidb@codeaurora.org>
 <4E3AD5E7.6040105@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E3AD5E7.6040105@codeaurora.org>
X-Cookie: You now have Asian Flu.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 04, 2011 at 10:24:55AM -0700, Stephen Boyd wrote:
> On 08/04/2011 09:24 AM, David Brown wrote:
> > Commit a0bfa1373859e9d11dc92561a8667588803e42d8 mispells
> > cpuidle_idle_call() on ARM and SH code.  Fix this to be consistent.

> > The referenced commit breaks compilation on ARM, and appears it would
> > do so on SH as well.

> Mark Brown sent this patch[1] months ago when this build breakage was
> noticed in linux-next. What happened to that patch? It looks like the
> patch that introduced the breakage was pulled from linux-next shortly
> after and then reintroduced today.

Yeah, as far as I remember Stephen applied my patch to -next as Len
didn't respond to it.
