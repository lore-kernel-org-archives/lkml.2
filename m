Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751538Ab1LRJqN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 04:46:13 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48148 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241Ab1LRJqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 04:46:10 -0500
Date: Sun, 18 Dec 2011 10:44:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Kevin Winchester <kjwinchester@gmail.com>
Cc: Steffen Persvold <sp@numascale.com>, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
        tglx@linutronix.de, daniel@numascale-asia.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/apic] x86: Add NumaChip support
Message-ID: <20111218094422.GA24404@elte.hu>
References: <1323101246-2400-1-git-send-email-daniel@numascale-asia.com>
 <tip-44b111b519160e33fdc41eadb39af86a24707edf@git.kernel.org>
 <20111205203130.GA12364@elte.hu>
 <4EDD5D77.3030101@numascale.com>
 <20111206055023.GB1580@elte.hu>
 <CAELBVzBqNHsnRP=dt7nwFWoigfX4FF6nQio+P+Fz71xQY0qK4Q@mail.gmail.com>
 <20111209072244.GG24537@elte.hu>
 <CAELBVzAWtTXvc+R1LkHT23SLERsFL5zUh5=_JoizXjJ7s0k8OA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAELBVzAWtTXvc+R1LkHT23SLERsFL5zUh5=_JoizXjJ7s0k8OA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
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


* Kevin Winchester <kjwinchester@gmail.com> wrote:

>  arch/x86/include/asm/processor.h     |    2 --
>  arch/x86/kernel/amd_nb.c             |    8 ++------
>  arch/x86/kernel/cpu/amd.c            |    2 --
>  arch/x86/kernel/cpu/common.c         |    7 -------
>  arch/x86/kernel/cpu/intel.c          |    2 --
>  arch/x86/kernel/cpu/mcheck/mce.c     |    2 --
>  arch/x86/kernel/cpu/mcheck/mce_amd.c |    7 +------
>  arch/x86/kernel/cpu/proc.c           |    4 +---
>  drivers/edac/sb_edac.c               |    2 --
>  drivers/hwmon/coretemp.c             |    6 ------
>  10 files changed, 4 insertions(+), 38 deletions(-)

This looks like a really nice cleanup - cleaning up more code 
than i anticipated.

If anyone wants to save those 267 they'll have to find a much 
cleaner and more maintainable way of doing it. Please put the 
size change info into the changelog.

The zero on UP is OK, the field is not used and zero is a fine 
initial value for an ID in any case.

Thanks,

	Ingo
