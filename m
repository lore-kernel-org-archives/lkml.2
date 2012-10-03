Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933195Ab2JCSGK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 14:06:10 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:39210 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932277Ab2JCSGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 14:06:09 -0400
Date: Wed, 3 Oct 2012 11:06:03 -0700
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Andi Kleen <andi@firstfloor.org>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCHv2 00/14] perf diff: Factor diff command
Message-ID: <20121003180603.GA18961@ghostprotocols.net>
References: <1348744175-11115-1-git-send-email-jolsa@redhat.com>
 <20120927213102.GO16230@one.firstfloor.org>
 <20121001081631.GB991@krava.brq.redhat.com>
 <20121002163002.GD16230@one.firstfloor.org>
 <20121003134757.GA18700@ghostprotocols.net>
 <20121003161816.GG16230@one.firstfloor.org>
 <20121003165342.GH16230@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121003165342.GH16230@one.firstfloor.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Oct 03, 2012 at 06:53:42PM +0200, Andi Kleen escreveu:
> The problem is with the perf-archive script. After some hacking I got it running
> now. I suspect the perf tool needs to pass its own executable name to
> the script to run.
> 
> Also would be nice if another file than perf.data could be specified
> (currently have to symlink)

It was done as a proof of concept to illustrate using scripts as
porcelain, just like in git, but yeah, it needs to be rewritten in C to
handle different filenames, etc, will try to move it to the head of my
todo list.

- Arnaldo
