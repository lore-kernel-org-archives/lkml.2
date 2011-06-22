Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779Ab1FVKw5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 06:52:57 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40124 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138Ab1FVKw4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 06:52:56 -0400
Subject: Re: [patch 03/16] sched: introduce primitives to account for CFS
 bandwidth tracking
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Nikhil Rao <ncrao@google.com>
In-Reply-To: <20110621071659.996203495@google.com>
References: <20110621071649.862846205@google.com>
	 <20110621071659.996203495@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 22 Jun 2011 12:52:04 +0200
Message-ID: <1308739924.1022.19.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-21 at 00:16 -0700, Paul Turner wrote:
> +#ifdef CONFIG_CFS_BANDWIDTH
> +       {
> +               .name = "cfs_quota_us",
> +               .read_s64 = cpu_cfs_quota_read_s64,
> +               .write_s64 = cpu_cfs_quota_write_s64,
> +       },
> +       {
> +               .name = "cfs_period_us",
> +               .read_u64 = cpu_cfs_period_read_u64,
> +               .write_u64 = cpu_cfs_period_write_u64,
> +       },
> +#endif 

Did I miss a reply to:
lkml.kernel.org/r/1305538202.2466.4047.camel@twins ? why does it make
sense to have different periods per cgroup? what does it mean?
