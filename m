Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770Ab1FNHa1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 03:30:27 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:54084 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754376Ab1FNHa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 03:30:26 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DF70DED.2030803@jp.fujitsu.com>
Date: Tue, 14 Jun 2011 16:29:49 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Hu Tao <hutao@cn.fujitsu.com>
CC: Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.co>
Subject: Re: [patch 00/15] CFS Bandwidth Control V6
References: <20110503092846.022272244@google.com> <20110614065807.GA19111@localhost.localdomain>
In-Reply-To: <20110614065807.GA19111@localhost.localdomain>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/06/14 15:58), Hu Tao wrote:
> Hi,
> 
> I've run several tests including hackbench, unixbench, massive-intr
> and kernel building. CPU is Intel(R) Xeon(R) CPU X3430  @ 2.40GHz,
> 4 cores, and 4G memory.
> 
> Most of the time the results differ few, but there are problems:
> 
> 1. unixbench: execl throughout has about 5% drop.
> 2. unixbench: process creation has about 5% drop.
> 3. massive-intr: when running 200 processes for 5mins, the number
>    of loops each process runs differ more than before cfs-bandwidth-v6.
> 
> The results are attached.

I know the score of unixbench is not so stable that the problem might
be noises ... but the result of massive-intr is interesting.
Could you give a try to find which piece (xx/15) in the series cause
the problems?

Thanks,
H.Seto

