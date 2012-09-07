Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667Ab2IGPeA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 11:34:00 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44440 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803Ab2IGPdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 11:33:55 -0400
Date: Fri, 7 Sep 2012 08:33:49 -0700
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 07/12] perf diff: Add ratio computation way to compare
 hist entries
Message-ID: <20120907153349.GC19165@ghostprotocols.net>
References: <1346946426-13496-1-git-send-email-jolsa@redhat.com>
 <1346946426-13496-8-git-send-email-jolsa@redhat.com>
 <871uiecrnr.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871uiecrnr.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Sep 07, 2012 at 02:45:28PM +0900, Namhyung Kim escreveu:
> On Thu,  6 Sep 2012 17:47:01 +0200, Jiri Olsa wrote:
> > @@ -263,6 +296,8 @@ static const struct option options[] = {
> > +	OPT_STRING('c', "compute", &compute_str, "delta,ratio (default delta)",
> > +		   "Entries differential computation selection"),
> 
> Why not make it OPT_CALLBACK?

Namhyung, please trim the message to contain just the snippet that is
related to your comment,

Thanks,

- Arnaldo
