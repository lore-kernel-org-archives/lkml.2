Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876Ab2AHPAX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 10:00:23 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43313 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752650Ab2AHPAV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 10:00:21 -0500
Date: Sun, 8 Jan 2012 16:00:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
Subject: Re: [ERROR] perf build failure on current tip:perf/core
Message-ID: <20120108150012.GA7570@elte.hu>
References: <1325950949.1486.20.camel@leonhard>
 <20120108090018.GB7168@elte.hu>
 <1326015664.1486.10.camel@leonhard>
 <20120108113426.GB26516@elte.hu>
 <87r4zaz88t.fsf@gmail.com>
 <20120108140318.GA15654@elte.hu>
 <1326034208.1508.15.camel@leonhard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326034208.1508.15.camel@leonhard>
User-Agent: Mutt/1.5.21 (2010-09-15)
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


* Namhyung Kim <namhyung@gmail.com> wrote:

> Putting the debug lines told me __USE_UNIX98 is not defined 
> for the file. It's because ctype.h gets included without 
> _GNU_SOURCE and then it includes feature.h AFAICS. 
> Encompassing ctype.h with #define/#undef _GNU_SOURCE or just 
> adding __USE_UNIX98 before unistd.h makes the file compiled, 
> but it seems like an improper solution. What is the right way?

Could you just remove the ctype.h include? AFAICS it's not 
needed in that file.

Thanks,

	Ingo
