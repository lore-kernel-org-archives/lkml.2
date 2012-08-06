Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185Ab2HFNFR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 09:05:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16377 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754334Ab2HFNFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 09:05:15 -0400
Message-ID: <501FC107.1020101@redhat.com>
Date: Mon, 06 Aug 2012 16:05:11 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 01/10] KVM: iommu: fix releasing unmapped page
References: <501B7F94.7090308@linux.vnet.ibm.com>
In-Reply-To: <501B7F94.7090308@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2012 10:36 AM, Xiao Guangrong wrote:
> There are two bugs:
> - the 'error page' is forgot to be released
>   [ it is unneeded after commit a2766325cf9f9, for backport, we
>     still do kvm_release_pfn_clean for the error pfn ]
> 
> - guest pages are always released regardless of the unmapped page
>   (e,g, caused by hwpoison)
> 

All applied, thanks.


-- 
error compiling committee.c: too many arguments to function
