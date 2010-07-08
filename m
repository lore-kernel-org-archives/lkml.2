Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453Ab0GHKSH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 06:18:07 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48601 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753480Ab0GHKSE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 06:18:04 -0400
Date: Thu, 8 Jul 2010 12:17:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Lin Ming <ming.m.lin@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: a.p.zijlstra@chello.nl, ling.ma@intel.com, linux-kernel@vger.kernel.org
Subject: Re: -tip tree panic
Message-ID: <20100708101753.GA32462@elte.hu>
References: <1278612020.2164.11.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278612020.2164.11.camel@localhost>
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


* Lin Ming <ming.m.lin@intel.com> wrote:

> I just tried latest -tip tree(commit 25fe86a), but it panics.

These commits might be relevant:

 bdc802d: x86, cpu: Support the features flags in new CPUID leaf 7
 83a7a2a: x86, alternatives: Use 16-bit numbers for cpufeature index
 24da9c2: x86, cpu: Add CPU flags for F16C and RDRND

So you could try reverting them. If that doesnt work out please try to bisect 
it.

Thanks,

	Ingo
