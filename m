Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757104Ab1CCK6J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 05:58:09 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57696 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751832Ab1CCK6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 05:58:08 -0500
Date: Thu, 3 Mar 2011 11:57:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <JBeulich@novell.com>
Cc: tglx@linutronix.de, hpa@zytor.com, Shaohua Li <shaohua.li@intel.com>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: work around old gas bug (try 2)
Message-ID: <20110303105755.GA24181@elte.hu>
References: <4D6F81B10200007800034B0B@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6F81B10200007800034B0B@vpn.id2.novell.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Beulich <JBeulich@novell.com> wrote:

> Add extra parentheses around a couple of definitions introduced by
> "x86: Cleanup vector usage" and used in assembly macro arguments, and
> remove spaces. Without that old (2.16.1) gas would see more macro
> arguments than were actually specified.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Shaohua Li <shaohua.li@intel.com>

Wondering, have you managed to test this with 2.16, or should i wait for akpm's 
testing before applying it?

Thanks,

	Ingo
