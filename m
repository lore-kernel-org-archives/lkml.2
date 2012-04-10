Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756424Ab2DJKce (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 06:32:34 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:4487 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755525Ab2DJKcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 06:32:32 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 10 Apr 2012 03:32:18 -0700
Date: Tue, 10 Apr 2012 13:31:54 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Arjan van de Ven <arjan@linux.intel.com>
CC: Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>, Len Brown <len.brown@intel.com>,
        Kevin Hilman <khilman@ti.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Trinabh Gupta <g.trinabh@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] cpuidle: allow per cpu latencies
Message-ID: <20120410103154.GB22721@tbergstrom-lnx.Nvidia.com>
References: <1333619620-21201-1-git-send-email-pdeschrijver@nvidia.com>
 <4F7DA009.4010802@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4F7DA009.4010802@linux.intel.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 05, 2012 at 03:37:13PM +0200, Arjan van de Ven wrote:
> On 4/5/2012 2:53 AM, Peter De Schrijver wrote:
> > This patch doesn't update all cpuidle device registrations. I will do that
> 
> question is if you want to do per cpu latencies, or if you want to have
> both types of C state in one big table, and have each of the tegra cpyu
> types pick half of them...
> 

How would the governor then know which C states belong to which CPUs?

Cheers,

Peter.
