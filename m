Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984Ab2BJGRX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 01:17:23 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33029 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752105Ab2BJGRV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 01:17:21 -0500
Date: Fri, 10 Feb 2012 07:17:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        hpa@zytor.com, mingo@redhat.com, davej@redhat.com,
        Borislav.Petkov@amd.com, stable@kernel.org, tglx@linutronix.de
Subject: Re: [tip:x86/urgent] x86/amd: Fix L1i and L2 cache sharing
 information for AMD family 15h processors
Message-ID: <20120210061708.GA26514@elte.hu>
References: <20120208195229.GA17523@alberich.amd.com>
 <tip-32c3233885eb10ac9cb9410f2f8cd64b8df2b2a1@git.kernel.org>
 <20120209133754.GA12584@elte.hu>
 <20120209153533.GG30341@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120209153533.GG30341@alberich.amd.com>
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


* Andreas Herrmann <andreas.herrmann3@amd.com> wrote:

> On Thu, Feb 09, 2012 at 02:37:54PM +0100, Ingo Molnar wrote:
> > 
> > This commit seems to cause a boot hang on an old Athlon64 CPU:
> 
> Are you sure that it's this commit, or is it possible that 
> some other patch in tip might trigger the trouble? (Systems 
> boots fine with this patch reverted?)

You are right, it's not this commit after all, but probably some 
other recent commit. I'll bisect it.

Thanks,

	Ingo
