Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348Ab2CHC3V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 21:29:21 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:35066 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299Ab2CHC26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 21:28:58 -0500
Message-ID: <4F581962.8040403@linux.vnet.ibm.com>
Date: Thu, 08 Mar 2012 10:28:50 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: William Irwin <wli@holomorphy.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] hugetlb: drop prev_vma in hugetlb_get_unmapped_area_topdown
References: <4F101904.8090405@linux.vnet.ibm.com> <4F101935.1040108@linux.vnet.ibm.com> <20120307140101.b0624e80.akpm@linux-foundation.org>
In-Reply-To: <20120307140101.b0624e80.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12030716-0260-0000-0000-000000A9AFA4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2012 06:01 AM, Andrew Morton wrote:

> On Fri, 13 Jan 2012 19:44:53 +0800
> Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com> wrote:
> 
>> Afte call find_vma_prev(mm, addr, &prev_vma), following condition is always
>> true:
>> 	!prev_vma || (addr >= prev_vma->vm_end)
>> it can be happily drop prev_vma and use find_vma instead of find_vma_prev
> 
> I had to rework this patch due to 097d59106a8e4b ("vm: avoid using
> find_vma_prev() unnecessarily") in mainline.  Can you please check my
> handiwork?
> 


It looks good to me, thanks Andrew!

