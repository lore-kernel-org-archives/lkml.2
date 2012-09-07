Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092Ab2IGQJH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 12:09:07 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40024 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781Ab2IGQJE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 12:09:04 -0400
Message-ID: <1347034126.18408.97.camel@twins>
Subject: Re: [PATCH 09/12] perf diff: Add weighted diff computation way to
 compare hist entries
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>
Date: Fri, 07 Sep 2012 18:08:46 +0200
In-Reply-To: <20120907153159.GB19165@ghostprotocols.net>
References: <1346946426-13496-1-git-send-email-jolsa@redhat.com>
	 <1346946426-13496-10-git-send-email-jolsa@redhat.com>
	 <87wr06bchw.fsf@sejong.aot.lge.com>
	 <20120907092831.GB3411@krava.brq.redhat.com>
	 <1347024784.1505.12.camel@leonhard>
	 <20120907153159.GB19165@ghostprotocols.net>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-07 at 08:31 -0700, Arnaldo Carvalho de Melo wrote:
> People don't like goto's, but that is overstated, for error handling
> it
> is perfectly fine :-) 

http://marc.info/?l=linux-arch&m=120852974023791&w=2

