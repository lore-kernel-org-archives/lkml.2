Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004Ab2HCUNA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 16:13:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17989 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752496Ab2HCUM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 16:12:59 -0400
Date: Fri, 3 Aug 2012 16:17:30 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 01/10] KVM: iommu: fix releasing unmapped page
Message-ID: <20120803191730.GA25688@amt.cnet>
References: <501B7F94.7090308@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <501B7F94.7090308@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2012 at 03:36:52PM +0800, Xiao Guangrong wrote:
> There are two bugs:
> - the 'error page' is forgot to be released
>   [ it is unneeded after commit a2766325cf9f9, for backport, we
>     still do kvm_release_pfn_clean for the error pfn ]
> 
> - guest pages are always released regardless of the unmapped page
>   (e,g, caused by hwpoison)
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>

Looks good.

