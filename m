Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653Ab1FUNDQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 09:03:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38353 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751477Ab1FUNDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 09:03:15 -0400
Date: Tue, 21 Jun 2011 15:03:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oprofile-list@lists.sourceforge.net" 
	<oprofile-list@lists.sourceforge.net>
Subject: Re: [GIT PULL] oprofile fixes for v3.0
Message-ID: <20110621130308.GA22088@elte.hu>
References: <20110621125219.GZ20052@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110621125219.GZ20052@erda.amd.com>
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


Robert,

* Robert Richter <robert.richter@amd.com> wrote:

> Ingo,
> 
> please pull oprofile fixes for v3.0 (tip/perf/urgent):
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git urgent
> 
> Thanks,
> 
> -Robert
> 
> 
> The following changes since commit 2c53b436a30867eb6b47dd7bab23ba638d1fb0d2:
> 
>   Linux 3.0-rc3 (2011-06-13 15:29:59 -0700)
> 
> are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git urgent
> 
> Robert Richter (2):
>       oprofile, x86: Fix race in nmi handler while starting counters
>       oprofile, x86: Fix nmi-unsafe callgraph support
> 
>  arch/x86/oprofile/backtrace.c |   56 ++++++++++++++++++++++++++++++++++------
>  arch/x86/oprofile/nmi_int.c   |   14 +++++++---
>  2 files changed, 57 insertions(+), 13 deletions(-)

Since when has NMI callgraph support been broken?

Thanks,

	Ingo
