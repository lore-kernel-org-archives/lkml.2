Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953Ab2AHPcu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 10:32:50 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:32905 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753691Ab2AHPct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 10:32:49 -0500
Date: Sun, 8 Jan 2012 16:32:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Namhyung Kim <namhyung@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: Fix compile error on x86_64 Ubuntu
Message-ID: <20120108153237.GA11891@elte.hu>
References: <20120108150012.GA7570@elte.hu>
 <1326035430-7621-1-git-send-email-namhyung@gmail.com>
 <20120108151207.GA26660@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120108151207.GA26660@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arnaldo Carvalho de Melo <acme@ghostprotocols.net> wrote:

> Em Mon, Jan 09, 2012 at 12:10:30AM +0900, Namhyung Kim escreveu:
> > ctype.h is not needed here and it breaks build on some system
> > (at least 64bit Ubuntu 10.04) like below. Just get rid of it.
> 
> Thanks, applying it together with your previous patchset.

Note that there are other ctype.h inclusions elsewhere as well, 
which should be considered for removal as well.

Thanks,

	Ingo
