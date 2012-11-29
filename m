Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553Ab2K2LyL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 06:54:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11568 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754389Ab2K2LyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 06:54:08 -0500
Date: Thu, 29 Nov 2012 12:53:18 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 08/14] perf diff: Change diff command to work over
 multiple data files
Message-ID: <20121129115318.GA1096@krava.brq.redhat.com>
References: <1354110769-2998-1-git-send-email-jolsa@redhat.com>
 <1354110769-2998-9-git-send-email-jolsa@redhat.com>
 <87mwy0od0x.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mwy0od0x.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 08:37:50PM +0900, Namhyung Kim wrote:
> On Wed, 28 Nov 2012 14:52:43 +0100, Jiri Olsa wrote:
> > Adding diff command the flexibility to specify multiple data
> > files on input. If not input file is given the standard behaviour
> > stands and diff inspects 'perf.data' and 'perf.data.old' files.
> >
> > Also changing the processing and output display for data files.
> >
> > For 'perf diff A B' command:
> >
> >   - the current way is to iterate over B data and display
> >     A (baseline) data (symbol samples) only if found in B
> >
> >   - this patch iterates over A (baseline) data and display
> >     B data (symbol samples) only if found in A
> >
> > For 'perf diff A B C' command, the diff now iterates the
> > A (baseline) data and display B and C data (symbol samples)
> > only if they found in A (baseline)
> >
> > All other standard diff command computation features
> > (delta,ratio,wdiff) stays.
> 
> This is quite a large change and IMHO can be separated into 3 patches at
> least.

you should have seen this patch before ;-)

> 
>  1) change he->pairs from list to array

ok

>  2) introduce diff_data__fmt
>  3) convert to diff_data__fmt

will try ;)

thanks,
jirka
