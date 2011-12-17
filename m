Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655Ab1LQSHH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 13:07:07 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59579 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118Ab1LQSHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 13:07:05 -0500
Message-ID: <4EECDA43.6040004@gmail.com>
Date: Sat, 17 Dec 2011 10:06:59 -0800
From: David Daney <david.s.daney@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc13 Thunderbird/3.1.10
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Ralf Baechle <ralf@linux-mips.org>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hillf Danton <dhillf@gmail.com>, David Daney <david.daney@cavium.com>,
        linux-mips@linux-mips.org,
        "Jayachandran C." <jayachandranc@netlogicmicro.com>
Subject: Re: linux-next: build failure after merge of the final tree (mips
 tree related)
References: <20111217155044.094c4c2b51af7c66e8ec90a3@canb.auug.org.au>
In-Reply-To: <20111217155044.094c4c2b51af7c66e8ec90a3@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2011 08:50 PM, Stephen Rothwell wrote:
> Hi all,
>
> After merging the final tree, today's linux-next build (mips almost all
> configs) failed like this:
>
> arch/mips/mm/tlb-r4k.c: In function 'local_flush_tlb_range':
> arch/mips/mm/tlb-r4k.c:128: error: 'HPAGE_SIZE' undeclared (first use in this function)
> arch/mips/mm/tlb-r4k.c:130: error: 'HPAGE_SHIFT' undeclared (first use in this function)
>
> Probably caused by commit 0b07e859f87b ("MIPS: Flush huge TLB").

Indeed that is the case.

We have a patch for this issue:  http://patchwork.linux-mips.org/patch/3114/

Perhaps Ralf will push out a mips-for-linux-next containing this patch 
in the near future.

David Daney
