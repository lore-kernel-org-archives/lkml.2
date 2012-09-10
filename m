Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716Ab2IJI0n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 04:26:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23359 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751420Ab2IJI0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 04:26:41 -0400
Message-ID: <504DA43B.1090202@redhat.com>
Date: Mon, 10 Sep 2012 11:26:35 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 3/3] KVM: MMU: remove unnecessary check
References: <5049908A.7070501@linux.vnet.ibm.com> <504990E7.6040604@linux.vnet.ibm.com>
In-Reply-To: <504990E7.6040604@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/2012 09:15 AM, Xiao Guangrong wrote:
> Checking the return of kvm_mmu_get_page is unnecessary since it is
> guaranteed by memory cache
> 


Thanks, applied.


-- 
error compiling committee.c: too many arguments to function
