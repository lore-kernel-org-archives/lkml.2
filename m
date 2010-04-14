Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756514Ab0DNQvw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 12:51:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53253 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755911Ab0DNQvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 12:51:50 -0400
Date: Wed, 14 Apr 2010 18:51:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cliff Wickman <cpw@sgi.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jack Steiner <steiner@sgi.com>, Russ Anderson <rja@sgi.com>,
       Mike Travis <travis@sgi.com>
Subject: Re: [PATCH v2] x86, UV: BAU performance and error recovery
Message-ID: <20100414165142.GA12902@elte.hu>
References: <E1O25Z4-0004Ur-PB@eag09.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1O25Z4-0004Ur-PB@eag09.americas.sgi.com>
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


* Cliff Wickman <cpw@sgi.com> wrote:

> This patch updates 2.6.34 up to what we've learned about BAU handling up to 
> 4/14/2010.  -cw

I've queued it up for v2.6.35.

Thanks,

	Ingo
