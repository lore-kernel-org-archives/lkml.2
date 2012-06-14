Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231Ab2FNCSn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 22:18:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:8465 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754826Ab2FNCSm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 22:18:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="157371290"
Message-ID: <4FD949FF.7060207@intel.com>
Date: Thu, 14 Jun 2012 10:18:39 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Stephane Eranian <eranian@google.com>, mingo@elte.hu, jolsa@redhat.com,
        andi@firstfloor.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V5 0/13] perf: Intel uncore pmu counting support
References: <1339479468-3815-1-git-send-email-zheng.z.yan@intel.com>  <CABPqkBQu1hTa2R-PKsygLqOSSD9nu3+xR-79pT-8bB8Y16CBuw@mail.gmail.com>  <4FD7EFCB.6060005@intel.com> <1339578142.31548.128.camel@twins>
In-Reply-To: <1339578142.31548.128.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2012 05:02 PM, Peter Zijlstra wrote:
> On Wed, 2012-06-13 at 09:41 +0800, Yan, Zheng wrote:
>> Peter suggests keeping the uncore names as they're listed in the intel
>> doc. For Sandybirdge-EP, uncore names are something like: Cbo, iMC,
>> QPI. 
> 
> No they're not, they're C-Box etc.. but I'm fine with doing a tolower on
> all of it.
> 

The reason I choose CBox instead of C-Box is that '-' is a separate symbol
in the flex rules. '-' is used for matching events such as LLC-load-misses.
I don't know how to allow letter '-' in the pmu name, but without leading
to ambiguity.

Regards
Yan, Zheng

