Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756437Ab0GHUMK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 16:12:10 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:52831 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755009Ab0GHUMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 16:12:08 -0400
Message-ID: <4C36300A.7030606@kernel.org>
Date: Thu, 08 Jul 2010 13:07:38 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100520 SUSE/3.0.5 Thunderbird/3.0.5
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH 03/23] lmb: Print new doubled array location info
References: <1278226587-31213-1-git-send-email-yinghai@kernel.org> <1278226587-31213-4-git-send-email-yinghai@kernel.org> <201007081255.58049.bjorn.helgaas@hp.com>
In-Reply-To: <201007081255.58049.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4C363101.00A8,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2010 11:55 AM, Bjorn Helgaas wrote:
> On Sunday, July 04, 2010 12:56:07 am Yinghai Lu wrote:
>> -		pr_info(" %s[0x%x]\t0x%016llx - 0x%016llx, 0x%llx bytes\n",
>> -		    name, i, base, base + size - 1, size);
>> +		pr_info(" %s[%#x]\t[%#016llx - %#016llx], %#llx bytes\n",
>> +		    name, i, base, base + size, size);
> 
> I know you think it's prettier to have zeroes and extra spaces like this:
> 
>   [0xe7000000 - 0xe8000000, 0x1000000 bytes]
> 
> rather than a bunch of 'F's:
> 
>   [0xe7000000-0xe7ffffff]
> 
> But for the record, I still think you're wrong and that it's better
> to be consistent even if it's slightly uglier.  The inconsistencies
> lead to confusion and off-by-one errors.

We can make them to be consistent later.

current for early mem stage, it is consistent to without -1.

later I like to see all pci resource could be consistent to without -1 too.

Thanks

Yinghai
