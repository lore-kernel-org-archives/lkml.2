Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932442Ab1EXT1c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 15:27:32 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48131 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753080Ab1EXT1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 15:27:31 -0400
Date: Tue, 24 May 2011 21:27:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@linux.jf.intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel: fix silly warning
Message-ID: <20110524192719.GG6561@elte.hu>
References: <20110524113517.18864.78312.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110524113517.18864.78312.stgit@localhost.localdomain>
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


* Alan Cox <alan@linux.jf.intel.com> wrote:

> () should be (void)
> 
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> ---
> 
>  kernel/watchdog.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/watchdog.c b/kernel/watchdog.c
> index 6e63097..7daa4b0 100644
> --- a/kernel/watchdog.c
> +++ b/kernel/watchdog.c
> @@ -98,7 +98,7 @@ __setup("nosoftlockup", nosoftlockup_setup);
>   * the thresholds with a factor: we make the soft threshold twice the amount of
>   * time the hard threshold is.
>   */
> -static int get_softlockup_thresh()
> +static int get_softlockup_thresh(void)

Yeah. This should already be fixed upstream, Linus pushed it out about 12 hours 
ago.

Thanks,

	Ingo
