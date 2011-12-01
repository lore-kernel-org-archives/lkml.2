Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227Ab1LAK2Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 05:28:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58605 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751110Ab1LAK2W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 05:28:22 -0500
Message-ID: <4ED756C1.5090501@redhat.com>
Date: Thu, 01 Dec 2011 12:28:17 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Jason Baron <jbaron@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/5] KVM: MMU: audit: replace mmu audit tracepoint with
 jump-lable
References: <4ED3811F.1070101@linux.vnet.ibm.com> <4ED3815C.9060901@linux.vnet.ibm.com> <20111128223305.GB2519@redhat.com> <4ED457D0.3010400@linux.vnet.ibm.com> <4ED4AD9E.1010604@redhat.com> <4ED5FABC.1080705@linux.vnet.ibm.com>
In-Reply-To: <4ED5FABC.1080705@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2011 11:43 AM, Xiao Guangrong wrote:
> Subject: [PATCH] KVM: MMU: audit: inline audit function
>
> inline audit function and little cleanup
>
>

Thanks, applied.

-- 
error compiling committee.c: too many arguments to function

