Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932885Ab0JXRLh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 13:11:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40078 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932203Ab0JXRLg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 13:11:36 -0400
Date: Sun, 24 Oct 2010 19:11:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Sitsofe Wheeler <sitsofe@yahoo.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: perf timechart segfault
Message-ID: <20101024171105.GA14276@elte.hu>
References: <20101024162302.GA5586@sucs.org>
 <20101024100356.7af1f4dd@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101024100356.7af1f4dd@infradead.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0009]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arjan van de Ven <arjan@infradead.org> wrote:

> > 2. (On -tip) Running
> >    perf timechart record echo
> >    outputs
> >    invalid or unsupported event: 'power:power_start'
> >    Run 'perf list' for a list of valid events
> 
> tip broke ABI :-(

hm, i'm not aware of that - where, which commit?

Thanks,

	Ingo
