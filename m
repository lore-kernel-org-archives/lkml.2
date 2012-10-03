Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933190Ab2JCQze (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 12:55:34 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43445 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932581Ab2JCQzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 12:55:33 -0400
Date: Wed, 3 Oct 2012 18:55:32 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCHv2 00/14] perf diff: Factor diff command
Message-ID: <20121003165532.GI16230@one.firstfloor.org>
References: <1348744175-11115-1-git-send-email-jolsa@redhat.com> <20120927213102.GO16230@one.firstfloor.org> <20121001081631.GB991@krava.brq.redhat.com> <20121002163002.GD16230@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121002163002.GD16230@one.firstfloor.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > hm, I missed this one.. hopefully it should be no problem to add it
> 
> Here's more issues I found (again no show stopper):

And another issue (this one is more serious):

I was trying to compare the same program with two different kernels.
But perf diff does not recognize the same functions in the kernels
as the same bucket. So I cannot actually "ratio" the different 
kernel versions.

-Andi
