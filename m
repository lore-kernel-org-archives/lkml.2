Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab1EPJXV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 05:23:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48053 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752737Ab1EPJXT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 05:23:19 -0400
Date: Mon, 16 May 2011 11:23:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jean Pihet <jean.pihet@newoldbits.com>
Cc: linux-kernel@vger.kernel.org, Thomas Renninger <trenn@suse.de>,
        Jean Pihet <j-pihet@ti.com>, linux-omap@vger.kernel.org,
        linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH] perf: export power_start and power_end tracepoints
Message-ID: <20110516092309.GD12325@elte.hu>
References: <1305297838-4015-1-git-send-email-j-pihet@ti.com>
 <20110513144830.GB32688@elte.hu>
 <BANLkTikkd9bNRLF1iDAz9Jwrnon3A=j44g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikkd9bNRLF1iDAz9Jwrnon3A=j44g@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jean Pihet <jean.pihet@newoldbits.com> wrote:

> Adding l-o and linux-pm MLs. The original post is at
> http://www.spinics.net/lists/kernel/msg1186554.html
> 
> On Fri, May 13, 2011 at 4:48 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * jean.pihet@newoldbits.com <jean.pihet@newoldbits.com> wrote:
> >
> >> From: Jean Pihet <j-pihet@ti.com>
> >>
> >> If used in a module both tracepoints need to be exported by the
> >> kernel.
> >
> > but it's not used by any module in the kernel AFAICS, so why is this needed?
> Not currently, that is why the error went unnoticed. I think it is
> better to fix it now than later.
> 
> I am working on a plan to clean-up and isolate the OMAP PM code from
> the core code and to provide the PM functionality as a module. This
> effort is part of the 'remove the crazy ARM churn' from the kernel.

Feel free to keep this patch with those modifications/cleanups:

Acked-by: Ingo Molnar <mingo@elte.hu>

but please make sure you push it together, i.e. never export something 
(knowingly) without having in-tree use for it.

Thanks,

	Ingo
