Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538Ab1AaKiG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 05:38:06 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45393 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755303Ab1AaKiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 05:38:05 -0500
Date: Mon, 31 Jan 2011 11:37:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Clark Williams <williams@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH 7/7] perf tools: Initial python binding
Message-ID: <20110131103746.GA32639@elte.hu>
References: <1296339559-20914-1-git-send-email-acme@infradead.org>
 <1296339559-20914-8-git-send-email-acme@infradead.org>
 <20110130134429.GF13616@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110130134429.GF13616@ghostprotocols.net>
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


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> Em Sat, Jan 29, 2011 at 08:19:19PM -0200, Arnaldo Carvalho de Melo escreveu:
> > From: Arnaldo Carvalho de Melo <acme@redhat.com>
> > 
> > First clarifying that this kind of binding is not a replacement or an
> > equivalent to the 'perf script' way of using python with perf.
> > 
> > The 'perf script' way is to process events and look at a given script
> > for some python function that matches the events to pass each event for
> > processing.
> 
> Ooops, forgot to add this to this cset, fixed it up and force pushed it
> there.
> 
> - Arnaldo

Pulled, thanks a lot Arnaldo!

	Ingo
