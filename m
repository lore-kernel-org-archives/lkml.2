Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891Ab0GFG7Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 02:59:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39056 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753181Ab0GFG7P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 02:59:15 -0400
Date: Tue, 6 Jul 2010 08:59:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Conny Seidel <conny.seidel@amd.com>,
       Borislav Petkov <borislav.petkov@amd.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 1/5] perf tools: Fix fallback to cplus_demangle() when
 bfd_demangle() is not available
Message-ID: <20100706065904.GC16224@elte.hu>
References: <1278378276-25872-1-git-send-email-acme@infradead.org>
 <1278378276-25872-2-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278378276-25872-2-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.5
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0380]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> From: Conny Seidel <conny.seidel@amd.com>
> 
> make version 3.80 doesn't support "else ifdef" on the same line, also it
> doesn't support unindented nested constructs.
> 
> Build fails with:
> Makefile:608: Extraneous text after `else' directive
> Makefile:611: *** only one `else' per conditional.  Stop.
> 
> This patch fixes the build for make 3.80.

Since 3.81 is the latest Make version and 3.80 is just one step before that, 
shouldnt we cherry-pick this into perf/urgent? (or is current upstream 
unaffected?)

Thanks,

	Ingo
