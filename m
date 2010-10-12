Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757103Ab0JLJaz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 05:30:55 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53902 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756954Ab0JLJay (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 05:30:54 -0400
Date: Tue, 12 Oct 2010 11:30:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: William Pitcock <nenolod@dereferenced.org>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, efault@gmx.de,
        kernel@kolivas.org
Subject: Re: [PATCH try 5] CFS: Add hierarchical tree-based penalty.
Message-ID: <20101012093044.GD20366@elte.hu>
References: <20101012092524.F0BF4CE142@carpathia.dereferenced.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101012092524.F0BF4CE142@carpathia.dereferenced.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.5
	-1.0 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0567]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* William Pitcock <nenolod@dereferenced.org> wrote:

> Inspired by the recent change to BFS by Con Kolivas, this patch causes 
> vruntime to be penalized based on parent depth from their root task 
> group.
> 
> I have, for the moment, decided to make it a default feature since the 
> design of CFS ensures that broken applications depending on task 
> enqueue behaviour behaving traditionally will continue to work.

Just curious, is this v5 submission a reply to Peter's earlier review of 
your v3 patch? If yes then please explicitly outline the changes you did 
so that Peter and others do not have to guess about the direction your 
work is taking.

Thanks,

	Ingo
