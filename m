Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947Ab2LTUas (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 15:30:48 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:38454 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432Ab2LTUam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 15:30:42 -0500
Message-ID: <50D37549.4010107@oracle.com>
Date: Thu, 20 Dec 2012 15:30:01 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/15] mm/huge_memory: use new hashtable implementation
References: <1355756497-15834-1-git-send-email-sasha.levin@oracle.com> <1355756497-15834-4-git-send-email-sasha.levin@oracle.com> <alpine.DEB.2.00.1212191416410.32757@chino.kir.corp.google.com> <50D27707.7060309@oracle.com> <alpine.DEB.2.00.1212201224190.29839@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1212201224190.29839@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2012 03:28 PM, David Rientjes wrote:
> On Wed, 19 Dec 2012, Sasha Levin wrote:
> 
>> In this case, the downside is that you'll waste 8KB if hugepages aren't available,
>> but the upside is that you'll have one less dereference when accessing the
>> hashtable.
>>
>> If the 8KB saving is preferable here I'll drop the patch and come back when
>> dynamic hashtable is supported.
>>
> 
> If a distro releases with CONFIG_TRANSPARNET_HUGEPAGE=y and a user is 
> running on a processor that does not support pse then this just cost them 
> 8KB for no reason.  The overhead by simply enabling 
> CONFIG_TRANSPARENT_HUGEPAGE is worse in this scenario, but this is whole 
> reason for having the dynamic allocation in the original code.  If there's 
> a compelling reason for why we want this change, then that fact should at 
> least be documented.
> 
> Could you propose a v2 that includes fixes for the other problems that 
> were mentioned?
> 

Sure, will do.


Thanks,
Sasha
