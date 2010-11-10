Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364Ab0KJHcr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 02:32:47 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58524 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752603Ab0KJHcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 02:32:46 -0500
Date: Wed, 10 Nov 2010 08:32:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: tzanussi@gmail.com, linux-kernel@vger.kernel.org, fweisbec@gmail.com
Subject: Re: [PATCH 0/7] perf trace command-line cleanup
Message-ID: <20101110073236.GA29493@elte.hu>
References: <1289337502-2492-1-git-send-email-tzanussi@gmail.com>
 <20101109213829.GB7883@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101109213829.GB7883@ghostprotocols.net>
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


* Arnaldo Carvalho de Melo <acme@ghostprotocols.net> wrote:

> Ingo,
> 
> 	Please pull from Tom's git tree, I'm traveling and can't do
> further tests, but all seems cool improvements,

I cannot pull it - the tree is based against tip:master, and the patches sent in 
email wont apply.

Tom, mind rebasing your fixes to perf/urgent [which is really just Linus's latest 
tree right now], with Arnaldo's Acked-by added to each patch?

Thanks,

	Ingo
