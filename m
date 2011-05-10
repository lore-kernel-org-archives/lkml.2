Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991Ab1EJH31 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 03:29:27 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46837 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754724Ab1EJH30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 03:29:26 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DC8E93F.1080803@jp.fujitsu.com>
Date: Tue, 10 May 2011 16:29:03 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Paul Turner <pjt@google.com>
CC: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [patch 15/15] sched: add documentation for bandwidth control
References: <20110503092846.022272244@google.com> <20110503092905.782248242@google.com>
In-Reply-To: <20110503092905.782248242@google.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/05/03 18:29), Paul Turner wrote:
> From: Bharata B Rao <bharata@linux.vnet.ibm.com>
> 
> Basic description of usage and effect for CFS Bandwidth Control.
> 
> Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
> Signed-off-by: Paul Turner <pjt@google.com>
> ---

Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>

Thank you very much for your great work, Paul!

I've run some test on this version and no problems so far
(other than minor bug pointed by 04/15).
Definitely things getting better.

I'll continue tests and let you know if there is something.


Thanks,
H.Seto

