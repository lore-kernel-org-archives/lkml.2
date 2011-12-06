Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779Ab1LFTzH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 14:55:07 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44348 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752850Ab1LFTzE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 14:55:04 -0500
Date: Tue, 6 Dec 2011 20:53:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, x86 maintainers <x86@kernel.org>
Subject: Re: linux-next: Tree for Dec 6 (x86, not SMP)
Message-ID: <20111206195320.GA886@elte.hu>
References: <20111206154450.5e2ef2baed27993b23a55802@canb.auug.org.au>
 <4EDE7EB7.7080507@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EDE7EB7.7080507@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Randy Dunlap <rdunlap@xenotime.net> wrote:

> On 12/05/2011 08:44 PM, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20111205:
> 
> 
> on x86, when CONFIG_SMP is not enabled:
> 
> arch/x86/kernel/cpu/common.c:1149:2: error: 'struct cpuinfo_x86' has no member named 'phys_proc_id'

Yeah, all resolved already, next day's linux-next ought to fix 
it.

Thanks,

	Ingo
