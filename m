Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932547Ab1EFTSa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 15:18:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53912 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932202Ab1EFTS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 15:18:29 -0400
Date: Fri, 6 May 2011 21:18:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mandeep Singh Baines <msb@google.com>
Subject: Re: [PATCH] softlockup: re-increase hung tasks check from 2 minutes
 to 8 minutes
Message-ID: <20110506191814.GE7151@elte.hu>
References: <4DC4153E.5020304@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DC4153E.5020304@suse.com>
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


* Jeff Mahoney <jeffm@suse.com> wrote:

>  Commit e162b39a, which moved the soft lockup code around a bit,
>  accidentally reverted commit fb822db4, which extended the soft lockup
>  timeout from 2 minutes to 8 minutes.
> 
>  This patch restores it to 8 minutes.

This patch wont apply, because i already have your other patch committed. Could 
you do it against latest -tip:

  http://people.redhat.com/mingo/tip.git/README

Thanks,

	Ingo
