Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920Ab1E3MSJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 08:18:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57334 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752885Ab1E3MSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 08:18:07 -0400
Date: Mon, 30 May 2011 14:17:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Damien Wyart <damien.wyart@free.fr>, Mike Galbraith <efault@gmx.de>,
        linux-kernel@vger.kernel.org, paulmck <paulmck@linux.vnet.ibm.com>
Subject: Re: Very high CPU load when idle with 3.0-rc1
Message-ID: <20110530121759.GI22324@elte.hu>
References: <20110530055924.GA9169@brouette>
 <1306755291.1200.2872.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306755291.1200.2872.camel@twins>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> The problem that patch tried to address is that the RCU threads 
> could stay in UNINTERRUPTIBLE state for quite a while and 
> triggering the hung task detector due to on-demand wake-ups.

and it's not just the hung task detector, but obviously also the load 
average itself that would be skewed in this original bug case as 
well.

Thanks,

	Ingo
