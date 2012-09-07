Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088Ab2IGPle (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 11:41:34 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64714 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022Ab2IGPld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 11:41:33 -0400
Subject: Re: [PATCH 07/12] perf diff: Add ratio computation way to compare
 hist entries
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>
In-Reply-To: <20120907153349.GC19165@ghostprotocols.net>
References: <1346946426-13496-1-git-send-email-jolsa@redhat.com>
	 <1346946426-13496-8-git-send-email-jolsa@redhat.com>
	 <871uiecrnr.fsf@sejong.aot.lge.com>
	 <20120907153349.GC19165@ghostprotocols.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 08 Sep 2012 00:41:26 +0900
Message-ID: <1347032486.1906.19.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-09-07 (금), 08:33 -0700, Arnaldo Carvalho de Melo:
> Em Fri, Sep 07, 2012 at 02:45:28PM +0900, Namhyung Kim escreveu:
> > On Thu,  6 Sep 2012 17:47:01 +0200, Jiri Olsa wrote:
> > > @@ -263,6 +296,8 @@ static const struct option options[] = {
> > > +	OPT_STRING('c', "compute", &compute_str, "delta,ratio (default delta)",
> > > +		   "Entries differential computation selection"),
> > 
> > Why not make it OPT_CALLBACK?
> 
> Namhyung, please trim the message to contain just the snippet that is
> related to your comment,

Will do that later.  Sorry for the inconvenience!

Thanks,
Namhyung


