Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962Ab0LVLRw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 06:17:52 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58478 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751335Ab0LVLRv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 06:17:51 -0500
Date: Wed, 22 Dec 2010 12:17:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Kees Cook <kees.cook@canonical.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        penberg@kernel.org, alan@lxorguk.ukuu.org.uk, tglx@linutronix.de,
        hpa@linux.intel.com
Subject: Re: [tip:x86/cpu] x86, cpu: Clear XD_DISABLED flag on Intel to
 regain NX
Message-ID: <20101222111725.GD3127@elte.hu>
References: <1289414154-7829-3-git-send-email-kees.cook@canonical.com>
 <tip-ae84739c27b6b3725993202fe02ff35ab86468e1@git.kernel.org>
 <20101208222713.GP5750@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101208222713.GP5750@outflux.net>
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


* Kees Cook <kees.cook@canonical.com> wrote:

> On Thu, Nov 11, 2010 at 02:49:04AM +0000, tip-bot for Kees Cook wrote:
> > Commit-ID:  ae84739c27b6b3725993202fe02ff35ab86468e1
> > Gitweb:     http://git.kernel.org/tip/ae84739c27b6b3725993202fe02ff35ab86468e1
> > Author:     Kees Cook <kees.cook@canonical.com>
> > AuthorDate: Wed, 10 Nov 2010 10:35:52 -0800
> > Committer:  H. Peter Anvin <hpa@linux.intel.com>
> > CommitDate: Wed, 10 Nov 2010 15:42:54 -0800
> > 
> > x86, cpu: Clear XD_DISABLED flag on Intel to regain NX
> 
> Just some quick positive feedback on this patch series: I've had at least one 
> confirmed report of a user with an Asus system that had NX disabled (in the BIOS 
> which offered no toggle to switch it on) is able to use the NX bit on their CPU 
> finally. Additionally, no regressions have been identified either, and there has 
> been a fair number of people running with the patch for a few weeks now in 
> Ubuntu's development kernel.

Nice!

	Ingo
