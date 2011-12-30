Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623Ab1L3J5T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Dec 2011 04:57:19 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37365 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752028Ab1L3J5R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Dec 2011 04:57:17 -0500
Date: Fri, 30 Dec 2011 10:55:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] perf script: Add script to collect and display IBS
 samples
Message-ID: <20111230095521.GA12077@elte.hu>
References: <1323969824-9711-1-git-send-email-robert.richter@amd.com>
 <1323969824-9711-5-git-send-email-robert.richter@amd.com>
 <20111223103329.GC4749@elte.hu>
 <20111223111958.GE16765@erda.amd.com>
 <20111223135340.GB21382@elte.hu>
 <1324649698.24803.55.camel@twins>
 <20111223144040.GB2297@elte.hu>
 <20111223161701.GF16765@erda.amd.com>
 <20111223163930.GA5983@elte.hu>
 <20111223165030.GG16765@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111223165030.GG16765@erda.amd.com>
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


* Robert Richter <robert.richter@amd.com> wrote:

> > Once something like 'perf report' works for some useful 
> > looking sub-case you can also tack on all the extra IBS 
> > goodies that specialized tools might need as well, i have no 
> > problem with providing that.
> 
> Isn't that outlook I gave about pebs like implementation of 
> the precise bit with IBS "useful enough"? This would be on top 
> patches anyway, so no need to hold back current patches.

An 'outlook' is not something I can test before sending commits 
to Linus.

To help your effort we could tentatively put the patches into a 
separate tip:perf/ibs topic branch if everyone agrees otherwise, 
which can go upstream once it's complete and usable.

Thanks,

	Ingo
