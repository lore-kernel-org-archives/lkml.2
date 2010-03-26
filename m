Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349Ab0CZICu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 04:02:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42199 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751988Ab0CZICq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 04:02:46 -0400
Date: Fri, 26 Mar 2010 09:02:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrea Gelmini <andrea.gelmini@gelma.net>
Cc: linux-doc@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/16] Tools perf builtin-trace.c: duplicated includes
Message-ID: <20100326080226.GC27394@elte.hu>
References: <1269537767-7553-1-git-send-email-andrea.gelmini@gelma.net>
 <1269537767-7553-13-git-send-email-andrea.gelmini@gelma.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269537767-7553-13-git-send-email-andrea.gelmini@gelma.net>
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


* Andrea Gelmini <andrea.gelmini@gelma.net> wrote:

> tools/perf/builtin-trace.c: util/exec_cmd.h and util/trace-event.h are included more than once.

Also, could you please update your patch to fix the subject lines of these 
auto-generated patches? The subject lines are missing a verb. The correct one 
would be:

 Subject: [PATCH 13/16] Tools perf builtin-trace.c: Remove duplicated #includes

Thanks,

	Ingo
