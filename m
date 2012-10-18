Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932263Ab2JRK5F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 06:57:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54779 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754197Ab2JRK5C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 06:57:02 -0400
Date: Thu, 18 Oct 2012 12:56:49 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/20] perf report: Add support for event group view (v3)
Message-ID: <20121018105649.GA11999@krava.brq.redhat.com>
References: <1349354994-17853-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349354994-17853-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2012 at 09:49:34PM +0900, Namhyung Kim wrote:
> Hi,
> 
> This is my v3 of event group view support.
> For basic idea and usage example, please see my original post [1].
> 
> I rebased the series on top of selected hpp changes from Jiri's diff
> patchset [2] since it contains cleanups and improves that can be used
> in this series too.
> 
> You can also get it via my tree at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git  perf/group-v3
> 
> Any comments are welcome, thanks,
> Namhyung
> 
> v2 -> v3:
>  * drop patch 1 since it's merged into acme/perf/core
>  * cherry-pick Jiri's hpp changes
>  * add missing bswap_32 on reading nr_groups (Jiri)
>  * remove perf_evlist__recalc_nr_groups() in favor of list_is_last (Jiri)

Acked-by: Jiri Olsa <jolsa@redhat.com>

for patches 10 to 20, the rest is already in

thanks,
jirka
