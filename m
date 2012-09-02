Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056Ab2IBNvk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 09:51:40 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:47849 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886Ab2IBNvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 09:51:37 -0400
Message-ID: <50436463.2070908@linux.vnet.ibm.com>
Date: Sun, 02 Sep 2012 21:51:31 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/6] KVM: MMU: release noslot pfn on the fail path properly
References: <5043578F.60602@linux.vnet.ibm.com>
In-Reply-To: <5043578F.60602@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12090213-3568-0000-0000-00000266ED0F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, i forgot to modify the patch title, total patch number is 3, so the title
should be 1/3, 2/3, 3/3. :(

On 09/02/2012 08:56 PM, Xiao Guangrong wrote:
> We can not directly call kvm_release_pfn_clean to release the pfn
> since we can meet noslot pfn which is used to cache mmio info into
> spte
> 
> Introduce mmu_release_pfn_clean to do this kind of thing
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>

