Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933973Ab1CXT1e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 15:27:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55324 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933917Ab1CXT1Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 15:27:24 -0400
Date: Thu, 24 Mar 2011 20:27:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, tj@kernel.org, npiggin@kernel.dk,
        rientjes@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [GIT PULL] SLAB changes for v2.6.39-rc1
Message-ID: <20110324192712.GA7156@elte.hu>
References: <alpine.DEB.2.00.1103221635400.4521@tiger>
 <20110324142146.GA11682@elte.hu>
 <alpine.DEB.2.00.1103240940570.32226@router.home>
 <AANLkTikb8rtSX5hQG6MQF4quymFUuh5Tw97TcpB0YfwS@mail.gmail.com>
 <20110324172653.GA28507@elte.hu>
 <alpine.DEB.2.00.1103242011540.4990@tiger>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1103242011540.4990@tiger>
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


* Pekka Enberg <penberg@kernel.org> wrote:

> >From dd1534455196d2a8f6c9c912db614e59986c9f0e Mon Sep 17 00:00:00 2001
> From: Pekka Enberg <penberg@kernel.org>
> Date: Thu, 24 Mar 2011 19:59:35 +0200
> Subject: [PATCH] x86: Early boot alternative instructions

hm, patch is whitespace damaged.

Also, the fix looks rather intrusive.

Could we please disable the lockless slub code first and then do everything 
with proper testing and re-enable the lockless code *after* we know that the 
alternatives fixup change is robust, etc? That way there's no rush needed.

There's a lot of code that could break from tweaking the alternatives code.

Thanks,

	Ingo
