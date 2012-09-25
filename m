Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198Ab2IYLGW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 07:06:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21261 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752503Ab2IYLGU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 07:06:20 -0400
Date: Tue, 25 Sep 2012 08:05:19 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Feng Tang <feng.tang@intel.com>, mingo@elte.hu, a.p.zijlstra@chello.nl,
        andi@firstfloor.org, dsahern@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/9] perf hists: Move hists_init() from util/evsel.c
 to util/hist.c
Message-ID: <20120925110519.GA28902@infradead.org>
References: <1348500251-9937-1-git-send-email-feng.tang@intel.com>
 <1348500251-9937-2-git-send-email-feng.tang@intel.com>
 <20120924160239.GD9977@infradead.org>
 <87pq5ayjuu.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pq5ayjuu.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Sep 25, 2012 at 10:25:13AM +0900, Namhyung Kim escreveu:
> On Mon, 24 Sep 2012 13:02:39 -0300, Arnaldo Carvalho de Melo wrote:
> > Em Mon, Sep 24, 2012 at 11:24:03PM +0800, Feng Tang escreveu:
> >> Which looks more natural
> >
> > It is there to avoid dragging the hist code into the python binding :-\
> 
> Hmm... it's so hairy.  Can't we do better?

We always can do better :-)

I just stated why it was at that place.

When doing refactorings we're all the time trying to make it better in
many senses, one of them is trying to isolate code that is useful in a
general way and thus should be made available via a library/scripting
binding.

- Arnaldo
