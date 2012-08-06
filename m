Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539Ab2HFCh3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 22:37:29 -0400
Received: from mga11.intel.com ([192.55.52.93]:3505 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755468Ab2HFCh2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 22:37:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="193573307"
Message-ID: <501F2DE9.3090900@intel.com>
Date: Mon, 06 Aug 2012 10:37:29 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 1/4] x86, CPU: Fixup tlb_flushall_shift formatting
References: <1344011869-21868-1-git-send-email-bp@amd64.org> <1344011869-21868-2-git-send-email-bp@amd64.org>
In-Reply-To: <1344011869-21868-2-git-send-email-bp@amd64.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/2012 12:37 AM, Borislav Petkov wrote:

> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> The TLB characteristics appeared like this in dmesg:
> 
> [    0.065817] Last level iTLB entries: 4KB 512, 2MB 1024, 4MB 512
> [    0.065817] Last level dTLB entries: 4KB 1024, 2MB 1024, 4MB 512
> [    0.065817] tlb_flushall_shift is 0xffffffff
> 
> where tlb_flushall_shift is actually -1 but dumped as a hex number.
> However, the Kconfig option CONFIG_DEBUG_TLBFLUSH and the rest of the
> code treats this as a signed decimal and states "If you set it to -1,
> the code flushes the whole TLB unconditionally."
> 
> So, fix its formatting in accordance with the other references to it.
> 
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>


Acked-by Alex Shi <alex.shi@intel.com>
