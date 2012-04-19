Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188Ab2DSKY4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 06:24:56 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6833 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108Ab2DSKYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 06:24:53 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 19 Apr 2012 03:24:30 -0700
Date: Thu, 19 Apr 2012 13:23:57 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@ti.com>, Len Brown <len.brown@intel.com>,
        Trinabh Gupta <g.trinabh@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arjan van de Ven <arjan@linux.intel.com>, Rob Lee <rob.lee@linaro.org>,
        Ricardo Salveti <ricardo.salveti@linaro.org>
Subject: Re: [RFC PATCH] cpuidle: allow per cpu latencies
Message-ID: <20120419102357.GJ514@tbergstrom-lnx.Nvidia.com>
References: <1333619620-21201-1-git-send-email-pdeschrijver@nvidia.com>
 <4F7DA009.4010802@linux.intel.com>
 <CAMQu2gzwe0F3qcaTqASEPUASdG1SjpUxrBrSp-RrYLgy3W24OQ@mail.gmail.com>
 <4F7F0D52.8080305@linaro.org>
 <20120410102857.GA22721@tbergstrom-lnx.Nvidia.com>
 <20120416153456.GB514@tbergstrom-lnx.Nvidia.com>
 <4F8FD773.5030500@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4F8FD773.5030500@linaro.org>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2012 at 11:14:27AM +0200, Daniel Lezcano wrote:
> On 04/16/2012 05:34 PM, Peter De Schrijver wrote:
> >>
> >> Maybe we also want to make the 'disabled' flag per CPU then or provide some
> >> other way the number of C states can be different per CPU?
> >
> > What do you think about this? Do we also want to make the disabled flag per
> > CPU? Or how should we deal with a different number of C states per CPU?
> 
> Hi Peter,
> 
> yes, that could makes sense. But in most of the architecture, this is 
> not needed, so duplicating the state's array and latencies is unneeded 
> memory consumption.
> 
> Maybe we can look for a COW approach, similar to what is done for the 
> nsproxy structure, no ?
> 

That could be easily solved by just having a pointer to the state table in the
per CPU datastructure I think?


Cheers,

Peter.
