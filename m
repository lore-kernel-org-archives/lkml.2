Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933054Ab2IFSla (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 14:41:30 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49577 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933001Ab2IFSl3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 14:41:29 -0400
Message-ID: <1346956869.18408.66.camel@twins>
Subject: Re: [RFC 00/12] perf diff: Factor diff command
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Date: Thu, 06 Sep 2012 20:41:09 +0200
In-Reply-To: <1346946426-13496-1-git-send-email-jolsa@redhat.com>
References: <1346946426-13496-1-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-06 at 17:46 +0200, Jiri Olsa wrote:
> The 'perf diff' and 'std/hist' code is now changed to allow computations
> mentioned in the paper. Two of them are implemented within this patchset:
>   1) ratio differential profiling
>   2) weighted differential profiling

Seems like a useful thing indeed, the explanation of the weighted diff
method doesn't seem to contain a why. I know I could go read the paper
but... :-)
