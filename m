Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716Ab0DUViV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 17:38:21 -0400
Received: from sabe.cs.wisc.edu ([128.105.6.20]:46529 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755329Ab0DUViT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 17:38:19 -0400
Message-ID: <4BCF7037.9070301@cs.wisc.edu>
Date: Wed, 21 Apr 2010 16:37:59 -0500
From: Mike Christie <michaelc@cs.wisc.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Konrad Rzeszutek Wilk <konrad@kernel.org>, linux-kernel@vger.kernel.org,
       gpxe-devel@etherboot.org, Peter Jones <pjones@redhat.com>
Subject: Re: [PATCH 2/2] ibft: For UEFI machines actually do scan ACPI for
 iBFT.
References: <1270822888-13192-1-git-send-email-konrad@kernel.org>	<1270822888-13192-3-git-send-email-konrad@kernel.org> <20100421142928.9699de85.akpm@linux-foundation.org>
In-Reply-To: <20100421142928.9699de85.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2010 04:29 PM, Andrew Morton wrote:
> On Fri,  9 Apr 2010 14:21:28 +0000
> Konrad Rzeszutek Wilk<konrad@kernel.org>  wrote:
>
>> For machines with IBFT 1.03 do scan the ACPI table for 'iBFT'
>> or for 'IBFT'. If the machine is in UEFI mode, only do the ACPI
>> table scan. For all other machines (pre IBFT 1.03) do
>> a memory scan if not found in the ACPI tables.
>>
>> Author: Konrad Rzeszutek Wilk<konrad@kernel.org>
>
> The Author: line is unneeded and inappropriate here.  That's what the
> From: line does.
>
>> Acked-by: Peter Jones<pjones@redhat.com>
>> Tested-by: Mike Christie<michaelc@cs.wisc.edu>
>> Signed-off-by: Konrad Rzeszutek Wilk<konrad@kernel.org>
>
> Your covering email indicates that Mike and Peter wrote the patches,
> but neither of the patches have their signoffs.  Can we please sort all
> this out?
>

I did a small fix to 
ibft-update-ibft-handling-for-v103-of-the-spec.patch to get it to 
compile. It looks like that patch has a "Reviewed-by: Mike Christie 
<michaelc@cs.wisc.edu>". Feel free to change that to a Signed-off-by: 
Mike Christie <michaelc@cs.wisc.edu> if needed.

I did not do any changes to 
ibft-for-uefi-machines-actually-do-scan-acpi-for-ibft.patch.

I tested both patches.
