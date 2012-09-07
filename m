Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468Ab2IGPcN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 11:32:13 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:61791 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755144Ab2IGPcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 11:32:08 -0400
Date: Fri, 7 Sep 2012 08:31:59 -0700
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 09/12] perf diff: Add weighted diff computation way to
 compare hist entries
Message-ID: <20120907153159.GB19165@ghostprotocols.net>
References: <1346946426-13496-1-git-send-email-jolsa@redhat.com>
 <1346946426-13496-10-git-send-email-jolsa@redhat.com>
 <87wr06bchw.fsf@sejong.aot.lge.com>
 <20120907092831.GB3411@krava.brq.redhat.com>
 <1347024784.1505.12.camel@leonhard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1347024784.1505.12.camel@leonhard>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Sep 07, 2012 at 10:33:04PM +0900, Namhyung Kim escreveu:
> 2012-09-07 (금), 11:28 +0200, Jiri Olsa:
> > On Fri, Sep 07, 2012 at 02:58:19PM +0900, Namhyung Kim wrote:
> > > I don't see why this do { } while(0) loop is necessary.
> > > How about this?
> > > 
> > > 	w1 = strtol(opt, &tmp, 10);
> > > 	if (*tmp != ',')
> > > 		goto error;
> > > 
> > > 	opt = tmp + 1;
> > > 	w2 = strtol(opt, &tmp, 10);
> > > 	if (*tmp != '\0')
> > > 		goto error;
> > > 
> > > 	if (!w1 || !w2)
> > > 		goto error;
> > 
> > I do this not to use labels & goto ;)
> 
> But isn't it usual?  Do you have a reason not to do it?

People don't like goto's, but that is overstated, for error handling it
is perfectly fine :-)

> I was a bit confused finding which path actually make it a loop... but
> there's none. :-/

- Arnaldo
