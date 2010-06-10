Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759508Ab0FJQV2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 12:21:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36373 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306Ab0FJQV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 12:21:27 -0400
Date: Thu, 10 Jun 2010 18:21:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Stephane Eranian <eranian@google.com>, Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [GIT PULL 0/1] perf/urgent fixes
Message-ID: <20100610162111.GB19599@elte.hu>
References: <1276185956-19099-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276185956-19099-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0006]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> Hi Ingo,
> 
>         Please pull from:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/urgent
> 
> Regards,
> 
> - Arnaldo
> 
> Arnaldo Carvalho de Melo (1):
>   perf record: Don't call newt functions when not initialized
> 
>  tools/perf/util/newt.c |   15 +++++++++++++--
>  1 files changed, 13 insertions(+), 2 deletions(-)

Pulled, thanks!

	Ingo
