Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515Ab1BVDSH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 22:18:07 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:60988 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075Ab1BVDSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 22:18:06 -0500
Date: Tue, 22 Feb 2011 08:47:59 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Gautham R Shenoy <ego@in.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Pavel Emelyanov <xemul@openvz.org>,
        Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
        Chris Friesen <cfriesen@nortel.com>
Subject: Re: [CFS Bandwidth Control v4 6/7] sched: hierarchical task
 accounting for SCHED_OTHER
Message-ID: <20110222031759.GJ10342@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20110216031831.571628191@google.com>
 <20110216031841.352204682@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20110216031841.352204682@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul Turner <pjt@google.com> [2011-02-15 19:18:37]:

> +#ifdef CONFIG_CFS_BANDWIDTH
> +/* maintain hierarchal task counts on group entities */
> +static void account_hier_tasks(struct sched_entity *se, int delta)

I don't like the use of hier, I'd expand it to hierarchical

I am not too sure about the RT bits, but other than that


Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
 

-- 
	Three Cheers,
	Balbir
