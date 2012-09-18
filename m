Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932665Ab2IRDLf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 23:11:35 -0400
Received: from mga09.intel.com ([134.134.136.24]:4115 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932087Ab2IRDLe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 23:11:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,439,1344236400"; 
   d="scan'208";a="194186436"
Message-ID: <5057E660.3040308@intel.com>
Date: Tue, 18 Sep 2012 11:11:28 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Jiri Olsa <jolsa@redhat.com>, eranian@google.com, a.p.zijlstra@chello.nl,
        mingo@elte.hu, andi@firstfloor.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 3/3] perf tool: Allow wildcard in PMU name
References: <1347263631-23175-1-git-send-email-zheng.z.yan@intel.com> <1347263631-23175-4-git-send-email-zheng.z.yan@intel.com> <20120911142717.GD3800@krava.brq.redhat.com> <20120917153608.GB31375@ghostprotocols.net>
In-Reply-To: <20120917153608.GB31375@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2012 11:36 PM, Arnaldo Carvalho de Melo wrote:
> Em Tue, Sep 11, 2012 at 04:27:17PM +0200, Jiri Olsa escreveu:
>> On Mon, Sep 10, 2012 at 03:53:51PM +0800, Yan, Zheng wrote:
>>
>> Would it be possible to have all '*add_event' more obvious for usage.
>> Also following code is duplicated after each call of __add_event:
>>
>>       evsel = __add_event(idx, &attr, pmu_event_name(head_config),
>>                           pmu->cpus);
>>       if (!evsel) {
>>               *idx = orig_idx;
>>               free_event_list(list);
>>               return -ENOMEM;
>>       }
>>       list_add_tail(&evsel->node, list);
> 
> Any update here? Yan, did you look at folding Jiri's patch? I'm merging
> the first bit, the kernel part, that was Acked by Ingo and Peter,
> waiting on this part, looking at 2/3 now
> 

Hi,

This patch still need some improvement, I don't expect it to get merged.
Please merged the patch 1 and patch 2 first. I will send a new one soon.

Regards
Yan, Zheng

