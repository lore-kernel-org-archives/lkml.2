Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310Ab1JRGPW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 02:15:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56817 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752562Ab1JRGPV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 02:15:21 -0400
Date: Tue, 18 Oct 2011 08:13:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>
Subject: Re: [PATCH 4/5] oprofile: Remove exit function for timer mode
Message-ID: <20111018061346.GD16304@elte.hu>
References: <1318861624-715-1-git-send-email-robert.richter@amd.com>
 <1318861624-715-5-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318861624-715-5-git-send-email-robert.richter@amd.com>
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

>  	/* failed */
> -	if (timer_mode)
> -		oprofile_timer_exit();
> -	else
> +	if (!timer_mode)
>  		oprofile_arch_exit();

> -	if (timer_mode)
> -		oprofile_timer_exit();
> -	else
> +	if (!timer_mode)
>  		oprofile_arch_exit();

... and the ugliness didnt improve much here either.

Any reason why oprofile_arch_exit() couldnt check timer_mode?

Thanks,

	Ingo
