Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849Ab1BODKG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 22:10:06 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41703 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934Ab1BODKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 22:10:03 -0500
Date: Tue, 15 Feb 2011 04:09:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oprofile-list@lists.sourceforge.net" 
	<oprofile-list@lists.sourceforge.net>
Subject: Re: [GIT PULL] oprofile fixes for v2.6.38
Message-ID: <20110215030951.GH31134@elte.hu>
References: <20110214194929.GX5874@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110214194929.GX5874@erda.amd.com>
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


* Robert Richter <robert.richter@amd.com> wrote:

> Ingo,
> 
> please pull oprofile fixes for tip/perf/urgent (v2.6.38):
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git urgent
> 
> Thanks,
> 
> -Robert
> 
> 
> 
> The following changes since commit 1bae4ce27c9c90344f23c65ea6966c50ffeae2f5:
> 
>   Linux 2.6.38-rc2 (2011-01-21 19:01:34 -0800)
> 
> are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git for-next
> 
> Ari Kauppi (2):
>       oprofile: Fix usage of CONFIG_HW_PERF_EVENTS for oprofile_perf_init and friends
>       ARM: oprofile: Fix backtraces in timer mode
> 
>  arch/arm/oprofile/common.c |   12 ++----------
>  include/linux/oprofile.h   |   13 +++++++++++--
>  2 files changed, 13 insertions(+), 12 deletions(-)

Pulled, thanks Robert!

	Ingo
