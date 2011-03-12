Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009Ab1CLOGb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 09:06:31 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54509 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752140Ab1CLOGa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 09:06:30 -0500
Date: Sat, 12 Mar 2011 15:06:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: yinghai@kernel.org, tglx@linutronix.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>
Subject: Re: [GIT PULL tip:x86/mm] x86-64 NUMA emulation update
Message-ID: <20110312140618.GA26865@elte.hu>
References: <20110312104727.GA2005@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110312104727.GA2005@htj.dyndns.org>
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


* Tejun Heo <tj@kernel.org> wrote:

> Hello, Ingo.
> 
> Please pull from the following branch to receive a commit which avoids
> unnecessary MAX_NUMNODES^2 looping.  HEAD is 56396e682.
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git x86-mm
> 
> As usual, if HEAD doesn't appear, please pull from master.
> 
>   ssh://master.kernel.org/pub/scm/linux/kernel/git/tj/misc.git x86-mm
> 
> Thanks.
> 
> Tejun Heo (1):
>       x86-64, NUMA: Don't call numa_set_distanc() for all possible node combinations during emulation
> 
>  arch/x86/mm/numa_emulation.c |   23 ++++++++++++-----------
>  1 files changed, 12 insertions(+), 11 deletions(-)

Pulled, thanks guys!

	Ingo
