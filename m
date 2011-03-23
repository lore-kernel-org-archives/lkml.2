Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932817Ab1CWM5S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 08:57:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56024 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932745Ab1CWM5R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 08:57:17 -0400
Date: Wed, 23 Mar 2011 13:57:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] lockdep: remove unused factor variable from
 lockdep_stats_show
Message-ID: <20110323125705.GA18862@elte.hu>
References: <20110323123828.GB4244@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110323123828.GB4244@swordfish.minsk.epam.com>
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


* Sergey Senozhatsky <sergey.senozhatsky@gmail.com> wrote:

> lockdep: remove unused factor variable from lockdep_stats_show

Please use more readable subject lines in the future. I have changed this one 
to:

  lockdep: Remove unused 'factor' variable from lockdep_stats_show()

Note the capitalization of the sentence, the quotes and the brackets - all 
which which help readability by structuring/differentiating various parts of 
the title properly.

Thanks,

	Ingo
