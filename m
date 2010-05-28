Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757911Ab0E1Jd0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 05:33:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38083 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753930Ab0E1JdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 05:33:23 -0400
Date: Fri, 28 May 2010 11:33:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cliff Wickman <cpw@sgi.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH V3] x86, UV: BAU performance and error recovery
Message-ID: <20100528093313.GF24058@elte.hu>
References: <E1OGxWi-0000kI-Tc@eag09.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1OGxWi-0000kI-Tc@eag09.americas.sgi.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.5
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cliff Wickman <cpw@sgi.com> wrote:

> Ingo,
> This patch replaces the patch of the same name, from March 2010.
> You had queued it up for v2.6.35 on April 14.

FYI, those bits are upstream now:

  b8f7fb1: x86, UV: Improve BAU performance and error recovery

And will be in v2.6.35.

Please send your latest improvements against latest -tip.

Thanks,

	Ingo
