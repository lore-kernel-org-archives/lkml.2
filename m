Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756125Ab1DRRdB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 13:33:01 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:3064 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755925Ab1DRRcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 13:32:55 -0400
Message-ID: <4DAC75C6.2060504@caviumnetworks.com>
Date: Mon, 18 Apr 2011 10:32:54 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Kevin Cernekee <cernekee@gmail.com>
CC: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] MIPS: Replace _PAGE_READ with _PAGE_NO_READ
References: <7aa38c32b7748a95e814e5bb0583f967@localhost>
In-Reply-To: <7aa38c32b7748a95e814e5bb0583f967@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Apr 2011 17:32:54.0540 (UTC) FILETIME=[A65DCCC0:01CBFDEE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2011 09:44 AM, Kevin Cernekee wrote:
> Reuse more of the same definitions for the non-RIXI and RIXI cases.  This
> avoids having special cases for kernel_uses_smartmips_rixi cluttering up
> the pgtable*.h files.
>
> On hardware that does not support RI/XI, EntryLo bits 31:30 / 63:62 will
> remain unset and RI/XI permissions will not be enforced.
>
> Signed-off-by: Kevin Cernekee<cernekee@gmail.com>
> ---
>   arch/mips/include/asm/pgtable-bits.h |   23 ++++++++---------------
>   arch/mips/include/asm/pgtable.h      |   21 ++++++++-------------
>   arch/mips/mm/tlbex.c                 |   17 +++++------------
>   3 files changed, 21 insertions(+), 40 deletions(-)
>
[...]

I like this patch.

How much testing have you done on non-RI/XI CPUs?

David Daney
