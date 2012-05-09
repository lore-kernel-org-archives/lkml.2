Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758346Ab2EIPEZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 11:04:25 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:23003 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758258Ab2EIPEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 11:04:22 -0400
Message-ID: <1336575858.2498.7.camel@lorien2>
Subject: Re: [PATCH 1/5] Fix soft-lookup in stop machine on secondary cpu
 bring up
From: Shuah Khan <shuahkhan@gmail.com>
Reply-To: shuahkhan@gmail.com
To: Igor Mammedov <imammedo@redhat.com>
Cc: shuahkhan@gmail.com, linux-kernel@vger.kernel.org, rob@landley.net,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        luto@mit.edu, suresh.b.siddha@intel.com, avi@redhat.com,
        a.p.zijlstra@chello.nl, johnstul@us.ibm.com, arjan@linux.intel.com,
        linux-doc@vger.kernel.org
Date: Wed, 09 May 2012 09:04:18 -0600
In-Reply-To: <1336559102-28103-2-git-send-email-imammedo@redhat.com>
References: <1336559102-28103-1-git-send-email-imammedo@redhat.com>
	 <1336559102-28103-2-git-send-email-imammedo@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-09 at 12:24 +0200, Igor Mammedov wrote:
> When bringing up cpuX1, it could stall in start_secondary
> before setting cpu_callin_mask for more than 5 sec. That forces
> do_boot_cpu() to give up on waiting and go to error return path
> printing messages:
>   pr_err("CPU%d: Stuck ??\n", cpuX1);

I am seeing this with the linux-next May 7th build on my laptop HP
EliteBook 8440p during boot. Could this problem be not specific to virt
envs.? Anybody else seeing it?

-- Shuah


