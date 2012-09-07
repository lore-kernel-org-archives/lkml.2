Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759309Ab2IGNdO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 09:33:14 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62014 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754994Ab2IGNdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 09:33:10 -0400
Subject: Re: [PATCH 09/12] perf diff: Add weighted diff computation way to
 compare hist entries
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>
In-Reply-To: <20120907092831.GB3411@krava.brq.redhat.com>
References: <1346946426-13496-1-git-send-email-jolsa@redhat.com>
	 <1346946426-13496-10-git-send-email-jolsa@redhat.com>
	 <87wr06bchw.fsf@sejong.aot.lge.com>
	 <20120907092831.GB3411@krava.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 Sep 2012 22:33:04 +0900
Message-ID: <1347024784.1505.12.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-09-07 (금), 11:28 +0200, Jiri Olsa:
> On Fri, Sep 07, 2012 at 02:58:19PM +0900, Namhyung Kim wrote:
> > I don't see why this do { } while(0) loop is necessary.
> > How about this?
> > 
> > 	w1 = strtol(opt, &tmp, 10);
> > 	if (*tmp != ',')
> > 		goto error;
> > 
> > 	opt = tmp + 1;
> > 	w2 = strtol(opt, &tmp, 10);
> > 	if (*tmp != '\0')
> > 		goto error;
> > 
> > 	if (!w1 || !w2)
> > 		goto error;
> 
> I do this not to use labels & goto ;)

But isn't it usual?  Do you have a reason not to do it?

I was a bit confused finding which path actually make it a loop... but
there's none. :-/

Thanks,
Namhyung


