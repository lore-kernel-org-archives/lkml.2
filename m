Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992Ab1KWKnn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 05:43:43 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:53586 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753621Ab1KWKnl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 05:43:41 -0500
Date: Wed, 23 Nov 2011 16:12:06 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree
 (uprobes tree related)
Message-ID: <20111123104206.GB22971@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20111123144409.7d1816bef960a2f277aaf1b9@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20111123144409.7d1816bef960a2f277aaf1b9@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11112310-7182-0000-0000-0000003E218D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> After merging the final tree, today's linux-next build (powerpc
> allnoconfig) failed like this:
> 
> In file included from include/linux/mm_types.h:15:0,
>                  from include/linux/sched.h:64,
>                  from arch/powerpc/mm/mem.c:21:
> include/linux/uprobes.h:174:49: error: 'struct mm_struct' declared inside parameter list [-Werror]
> include/linux/uprobes.h:174:49: error: its scope is only this definition or declaration, which is probably not what you want [-Werror]
> 
> And many more similar.
> 
> Caused by commit 61fafad13005 ("uprobes_xol" - "uprobes: slot allocation").


Thanks for reporting this. 
I have folded your fix into the patch.

-- 
Thanks and Regards
Srikar

