Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912Ab1BHPTy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 10:19:54 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37096 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752773Ab1BHPTu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 10:19:50 -0500
Date: Tue, 8 Feb 2011 16:19:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, paulus@samba.org, davem@davemloft.net,
        fweisbec@gmail.com, perfmon2-devel@lists.sf.net, eranian@gmail.com,
        robert.richter@amd.com, Borislav Petkov <bp@amd64.org>
Subject: Re: [PATCH] perf: fix compile error in annotate.h
Message-ID: <20110208151925.GC20357@elte.hu>
References: <4d51432a.a7fed80a.1571.fffffe9f@mx.google.com>
 <20110208135144.GE7651@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110208135144.GE7651@ghostprotocols.net>
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


* Arnaldo Carvalho de Melo <acme@redhat.com> wrote:

> Em Tue, Feb 08, 2011 at 02:20:01PM +0200, Stephane Eranian escreveu:
> > The following patch is necessary to compile without NEWT.
> 
> Merged already, Borislav Petkov sent a similar patch.

I just pushed it out - Stephane, mind checking that latest -tip indeed fixes things 
for you?

Thanks,

	Ingo
