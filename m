Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932566Ab1BYK06 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 05:26:58 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59580 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932510Ab1BYK05 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 05:26:57 -0500
Date: Fri, 25 Feb 2011 11:26:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Cliff Wickman <cpw@sgi.com>, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, paulus@samba.org
Subject: Re: [RFC] Performance Events 'Samples' report
Message-ID: <20110225102647.GA4228@elte.hu>
References: <E1PslLC-0000rj-EF@eag09.americas.sgi.com>
 <20110225024014.GA16138@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110225024014.GA16138@ghostprotocols.net>
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

> Wasn't this fixed by:
> 
> commit fec9cbd15b9e99bab9bc50f1ed7e20a1087d7c6d
> Author: Arnaldo Carvalho de Melo <acme@redhat.com>
> Date:   Thu Feb 17 10:37:23 2011 -0200
> 
>     perf hists: Print number of samples, not the period sum

Yeah. I'll cherry-pick it over into perf/urgent, ok? It's been reported by several 
people (I noticed it too) and the old numbers really made little sense - and the fix 
is really simple.

Thanks,

	Ingo
