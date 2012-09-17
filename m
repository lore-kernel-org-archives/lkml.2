Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173Ab2IQPgT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 11:36:19 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:38729 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405Ab2IQPgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 11:36:18 -0400
Date: Mon, 17 Sep 2012 08:36:08 -0700
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: "Yan, Zheng" <zheng.z.yan@intel.com>, Jiri Olsa <jolsa@redhat.com>
Cc: eranian@google.com, a.p.zijlstra@chello.nl, mingo@elte.hu,
        andi@firstfloor.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 3/3] perf tool: Allow wildcard in PMU name
Message-ID: <20120917153608.GB31375@ghostprotocols.net>
References: <1347263631-23175-1-git-send-email-zheng.z.yan@intel.com>
 <1347263631-23175-4-git-send-email-zheng.z.yan@intel.com>
 <20120911142717.GD3800@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120911142717.GD3800@krava.brq.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Sep 11, 2012 at 04:27:17PM +0200, Jiri Olsa escreveu:
> On Mon, Sep 10, 2012 at 03:53:51PM +0800, Yan, Zheng wrote:
> 
> Would it be possible to have all '*add_event' more obvious for usage.
> Also following code is duplicated after each call of __add_event:
> 
>       evsel = __add_event(idx, &attr, pmu_event_name(head_config),
>                           pmu->cpus);
>       if (!evsel) {
>               *idx = orig_idx;
>               free_event_list(list);
>               return -ENOMEM;
>       }
>       list_add_tail(&evsel->node, list);

Any update here? Yan, did you look at folding Jiri's patch? I'm merging
the first bit, the kernel part, that was Acked by Ingo and Peter,
waiting on this part, looking at 2/3 now

- Arnaldo
