Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369Ab2K2MOE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 07:14:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58852 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753766Ab2K2MOC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 07:14:02 -0500
Date: Thu, 29 Nov 2012 13:13:19 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 10/14] perf tool: Centralize default columns init in
 perf_hpp__init
Message-ID: <20121129121319.GD1096@krava.brq.redhat.com>
References: <1354110769-2998-1-git-send-email-jolsa@redhat.com>
 <1354110769-2998-11-git-send-email-jolsa@redhat.com>
 <87ehjcoc70.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ehjcoc70.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 08:55:47PM +0900, Namhyung Kim wrote:
> On Wed, 28 Nov 2012 14:52:45 +0100, Jiri Olsa wrote:
> > Now when diff command is separated from other standard outputs,
> > we can use perf_hpp__init to initialize all standard columns.
> >
> > Moving PERF_HPP__OVERHEAD column init back to perf_hpp__init,
> > and removing extra enable calls.
> 
> Why was this needed in the first place?  AFAIK it's already there and
> didn't used only for perf diff.

hm, I think PERF_HPP__OVERHEAD wasn't part of perf_hpp__init and every
report except for diff command is using it.. so I think it makes sense
to move it to perf_hpp__init.. maybe I'm missing something.

The diff command is not using perf_hpp__init, it's building its own
PERF_HPP columns

jirka
