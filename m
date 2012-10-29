Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758656Ab2J2LOO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 07:14:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53262 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758598Ab2J2LON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 07:14:13 -0400
Date: Mon, 29 Oct 2012 12:13:28 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 0/5] perf dso: Separate dso symbols to separate object
Message-ID: <20121029111328.GA1123@krava.redhat.com>
References: <1351372712-21104-1-git-send-email-jolsa@redhat.com>
 <87mwz57czf.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mwz57czf.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 08:07:48PM +0900, Namhyung Kim wrote:
> Hi Jiri,
> 
> On Sat, 27 Oct 2012 23:18:27 +0200, Jiri Olsa wrote:
> > hi,
> > separating dso related stuff into dso object plus some other symbol
> > object cleanup. It's just a code moving, no actual change was done.
> >
> > Attached patches:
> >   1/5 perf tool: Move build_id__sprintf into build-id object
> >   2/5 perf tool: Move BUILD_ID_SIZE into build-id object
> >   3/5 perf tool: Move hex2u64 into util object
> >   4/5 perf tool: Move strxfrchar into string object
> >   5/5 perf tool: Move dso_* related functions into dso object
> 
> Looks good to me.
> 
> Arnaldo, if you want, you can add my Reviewed- or Tested-by tags for this
> series.

humm, so you could compile it wth no problem..? what system are you? ;)

thanks,
jirka
