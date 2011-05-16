Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615Ab1EPKgG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 06:36:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45398 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754568Ab1EPKgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 06:36:04 -0400
Date: Mon, 16 May 2011 12:35:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Juri Lelli <juri.lelli@gmail.com>, linux-kernel@vger.kernel.org,
        Yong Zhang <yong.zhang0@gmail.com>
Subject: Re: [PATCH] Documentation: statistics about nested locks
Message-ID: <20110516103559.GA19837@elte.hu>
References: <4DD0F614.2040408@gmail.com>
 <1305540776.2466.4094.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305540776.2466.4094.camel@twins>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Mon, 2011-05-16 at 12:01 +0200, Juri Lelli wrote:
> > +The graph below shows the relation between the lock functions and the 
> > various
> > +hooks therein. 
> 
> That smells like the patch has whitespace damage..

Yeah, Documentation/email-clients.txt might help there.

Thanks,

	Ingo
