Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578Ab1BWOus (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 09:50:48 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56731 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752211Ab1BWOur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 09:50:47 -0500
Date: Wed, 23 Feb 2011 15:50:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [GIT PULL 0/2] perf/core TUI live annotate and a cleanup
Message-ID: <20110223145026.GA20686@elte.hu>
References: <1298400790-29453-1-git-send-email-acme@infradead.org>
 <20110223072842.GC15175@elte.hu>
 <1298446517.7856.143.camel@marge.simson.net>
 <1298471545.7846.17.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298471545.7846.17.camel@marge.simson.net>
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


* Mike Galbraith <efault@gmx.de> wrote:

> Works spiffy, and no lockup troubles (didn't get back to that, koff),
> much nicer than the old annotation.  I did notice that pressing left
> arrow one too many times leads to exit, dunno if that's intended.

I think it should at least ask for confirmation. Exiting on 'q' or escape 
immediately would be fine.

Thanks,

	Ingo
