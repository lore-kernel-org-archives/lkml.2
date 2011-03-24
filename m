Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933662Ab1CXH6q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 03:58:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33134 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933596Ab1CXH6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 03:58:45 -0400
Date: Thu, 24 Mar 2011 08:58:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf probe: Add fastpath to do lookup by function name
Message-ID: <20110324075830.GA28885@elte.hu>
References: <1300981134-7333-1-git-send-email-ming.m.lin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300981134-7333-1-git-send-email-ming.m.lin@intel.com>
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


* Lin Ming <ming.m.lin@intel.com> wrote:

> The vmlinux file may have thousands of CUs.
> We can lookup function name from .debug_pubnames section
> to avoid the slow loop on CUs.

Mind including before/after perf stat --repeat 10 results in the changelog, of 
an affected command which got faster?

Thanks,

	Ingo
