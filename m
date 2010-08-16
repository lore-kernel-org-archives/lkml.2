Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358Ab0HPPuv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 11:50:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59282 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390Ab0HPPuu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 11:50:50 -0400
Date: Mon, 16 Aug 2010 12:50:23 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Kusanagi Kouichi <slash@ac.auone-net.jp>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: Don't use brace expansion.
Message-ID: <20100816155022.GD13095@ghostprotocols.net>
References: <20100816124101.1829415C039@msa104.auone-net.jp> <1281967761.17267.6.camel@thorin> <1281969043.1926.1469.camel@laptop> <1281970478.17267.12.camel@thorin> <20100816152914.GC13095@ghostprotocols.net> <1281973427.17267.16.camel@thorin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281973427.17267.16.camel@thorin>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Aug 16, 2010 at 05:43:47PM +0200, Bernd Petrovitsch escreveu:
> On Mon, 2010-08-16 at 12:29 -0300, Arnaldo Carvalho de Melo wrote:
> > More seriously, so there is a reason for that to be like that and you're
> > not aware of any other shorter or more convenient way of achieving that

> One (obvious) alternative is to have rules triggering on the
> non-existence of these directories.

Can you provide those please?
 
> > goal, right?

> Hmm, I'm not a "perf person". Which are the sufficient use-cases/tests
> that one can do to play around with the Makefile?
> 
> `make -C tools/perf` is probably not enough.

Right, not enough, what those mkdir calls were added for was exactly for
a different usecase:

make -C tools/perf -O=~/build/perf/

So that it doesn't pollutes the source code directories with the object
files, behaving in a similar fashion as when using O= in the kernel
proper.
 
- Arnaldo
