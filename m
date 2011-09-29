Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854Ab1I2PgF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 11:36:05 -0400
Received: from fallback.mail.elte.hu ([157.181.151.13]:36568 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185Ab1I2PgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 11:36:03 -0400
Date: Thu, 29 Sep 2011 17:34:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oprofile-list@lists.sourceforge.net" 
	<oprofile-list@lists.sourceforge.net>
Subject: Re: [GIT PULL] oprofile updates for v3.2
Message-ID: <20110929153436.GA1243@elte.hu>
References: <20110929150413.GP6063@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110929150413.GP6063@erda.amd.com>
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


* Robert Richter <robert.richter@amd.com> wrote:

> Ingo,
> 
> please pull oprofile updates for v3.2 (tip/perf/core):
> 
>   git://amd64.org/linux/rric.git core
> 
> Thanks,
> 
> -Robert
> 
> 
> The following changes since commit d6eed550a9d08fbd1fce32e517e8c49afa6edbf7:
> 
>   x86: Perf_event_amd.c needs <asm/apicdef.h> (2011-09-27 19:55:09 +0200)
> 
> are available in the git repository at:
>   git://amd64.org/linux/rric.git core
> 
> Maarten Lankhorst (1):
>       oprofile, x86: Convert memory allocation to static array
> 
> Robert Richter (1):
>       oprofile, x86: Fix overflow and warning (commit 1d12d35)
> 
>  arch/x86/oprofile/op_model_ppro.c |   27 ++-------------------------
>  1 files changed, 2 insertions(+), 25 deletions(-)

Pulled, thanks Robert!

	Ingo
