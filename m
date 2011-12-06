Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933243Ab1LFLhx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 06:37:53 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:52739 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933207Ab1LFLhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 06:37:51 -0500
Message-ID: <4EDDFE79.9010109@linux.vnet.ibm.com>
Date: Tue, 06 Dec 2011 17:07:29 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
CC: daniel@numascale-asia.com, mingo@elte.hu, sp@numascale.com,
        jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH tip] Fix build failure x86_default_fixup_cpu_id() with
 !CONFIG_SMP
References: <20111206104755.GA8567@linux.vnet.ibm.com>
In-Reply-To: <20111206104755.GA8567@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11120601-5490-0000-0000-00000047D36C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kamalesh,

On 12/06/2011 04:17 PM, Kamalesh Babulal wrote:

> Hi,
> 
> tip (a4a7e7e29333) build fails, when compiled with !CONFIG_SMP. 
> I have only build tested the patch.
> 
> x86: Fix x86_default_fixup_cpu_id() build failure with !CONFIG_SMP
> 
> arch/x86/kernel/cpu/common.c: In function 'x86_default_fixup_cpu_id':
> arch/x86/kernel/cpu/common.c:1149: error: 'struct cpuinfo_x86' has no member named 'phys_proc_id'
> make[3]: *** [arch/x86/kernel/cpu/common.o] Error 1
> 
> the code was introduced by commit 64be4c1c24. This patch
> introduced #ifdef to guard !SMP case.
> 
> Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
> ----


There was a similar build-fix patch by Steffen Persvold at:
https://lkml.org/lkml/2011/12/6/28

That would solve your case too, right?

 

Regards,
Srivatsa S. Bhat

