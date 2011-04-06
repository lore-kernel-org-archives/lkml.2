Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192Ab1DFOPR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 10:15:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:56296 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755986Ab1DFOPQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 10:15:16 -0400
Subject: Re: [PATCH -tip v3 3/6] perf branch trace: print pid and command
From: Peter Zijlstra <peterz@infradead.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, David Ahern <dsahern@gmail.com>,
        Akihiro Nagai <akihiro.nagai.hw@hitachi.com>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        2nddept-manager@sdl.hitachi.co.jp, Paul Mackerras <paulus@samba.org>,
        Jiri Olsa <jolsa@redhat.com>
In-Reply-To: <20110406140958.GA4987@ghostprotocols.net>
References: <20110324113137.20235.42265.stgit@localhost6.localdomain6>
	 <20110324113209.20235.61900.stgit@localhost6.localdomain6>
	 <4D8B79E6.2050603@gmail.com> <4D8C6B1B.70409@hitachi.com>
	 <4D8CAE74.9080805@gmail.com> <4D906450.1040809@hitachi.com>
	 <4D909BBB.5020500@gmail.com> <20110401151313.GC2335@nowhere>
	 <4D96072E.4060902@gmail.com> <20110406121501.GA1867@nowhere>
	 <20110406140958.GA4987@ghostprotocols.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 06 Apr 2011 16:15:01 +0200
Message-ID: <1302099301.2225.1381.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-06 at 11:09 -0300, Arnaldo Carvalho de Melo wrote:
> > What we seem to need for that is to bring a pagefault tracepoint. We had
> > propositions for that in the past, but work on this is in pause mode it
> > seems. 

Huh, whot? You can get that using PERF_COUNT_SW_PAGE_FAULT and
PERF_SAMPLE_ADDR.
