Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759407Ab2HXNHR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 09:07:17 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:64728 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146Ab2HXNHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 09:07:14 -0400
Date: Fri, 24 Aug 2012 10:07:06 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC 00/13] perf test: Add perf_event_attr tests
Message-ID: <20120824130706.GA27708@infradead.org>
References: <1345798844-27423-1-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345798844-27423-1-git-send-email-jolsa@redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Aug 24, 2012 at 11:00:31AM +0200, Jiri Olsa escreveu:

>  tools/perf/util/test-attr.c                         | 142 ++++++++++++++++++++++++++
>  tools/perf/util/test-attr.py                        | 272 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  tools/perf/util/test-attr/base-record               |  39 ++++++++

I suggest we move all this to:

  tools/perf/tests/attr/

>  tools/perf/util/test-attr/base-stat                 |  39 ++++++++
>  tools/perf/util/test-attr/test-record-basic         |   5 +
>  tools/perf/util/test-attr/test-record-count         |   8 ++
>  tools/perf/util/test-attr/test-record-freq          |   6 ++
>  tools/perf/util/test-attr/test-record-graph-default |   6 ++
>  tools/perf/util/test-attr/test-record-graph-dwarf   |   6 ++
>  tools/perf/util/test-attr/test-record-graph-fp      |   6 ++
>  tools/perf/util/test-attr/test-record-group         |  17 ++++
>  tools/perf/util/test-attr/test-record-no-inherit    |   7 ++
>  tools/perf/util/test-attr/test-record-no-samples    |   6 ++
>  tools/perf/util/test-attr/test-record-period        |   7 ++
>  tools/perf/util/test-attr/test-stat-basic           |   6 ++
>  tools/perf/util/test-attr/test-stat-group           |  15 +++
>  tools/perf/util/test-attr/test-stat-no-inherit      |   7 ++
>  21 files changed, 612 insertions(+)
