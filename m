Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758533Ab0EFOVX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 10:21:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52504 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751907Ab0EFOVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 10:21:22 -0400
Date: Thu, 6 May 2010 16:21:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>
Subject: Re: [GIT PULL] updates for oprofile
Message-ID: <20100506142102.GB11113@elte.hu>
References: <1272969893-29233-1-git-send-email-robert.richter@amd.com>
 <20100506130306.GR6450@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100506130306.GR6450@erda.amd.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0004]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robert Richter <robert.richter@amd.com> wrote:

> Ingo,
> 
> please pull oprofile updates for tip from
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git core
> 
> Thanks,
> 
> -Robert
> 
> -- 
> 
> The following changes since commit 9414e99672271adcc661f3c160a30b374179b92f:
>   Phil Carmody (1):
>         oprofile: protect from not being in an IRQ context
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git core
> 
> Robert Richter (7):
>       oprofile: update file list in MAINTAINERS file
>       oprofile/x86: rework error handler in nmi_setup()
>       oprofile/x86: reserve counter msrs pairwise
>       oprofile/x86: moving shutdown functions
>       oprofile/x86: return -EBUSY if counters are already reserved
>       oprofile/x86: move IBS code
>       oprofile/x86: remove duplicate IBS capability check
> 
>  MAINTAINERS                       |    1 +
>  arch/x86/oprofile/nmi_int.c       |   38 ++++---
>  arch/x86/oprofile/op_model_amd.c  |  228 ++++++++++++++++++-------------------
>  arch/x86/oprofile/op_model_p4.c   |   52 +++++----
>  arch/x86/oprofile/op_model_ppro.c |   77 ++++++-------
>  arch/x86/oprofile/op_x86_model.h  |    2 +-
>  6 files changed, 206 insertions(+), 192 deletions(-)

Pulled, thanks Robert!

	Ingo
