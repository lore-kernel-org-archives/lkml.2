Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758105Ab0GEDCB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jul 2010 23:02:01 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64275 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755016Ab0GEDCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jul 2010 23:02:00 -0400
Message-ID: <4C314A40.7060206@cn.fujitsu.com>
Date: Mon, 05 Jul 2010 10:58:08 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Sheng Yang <sheng@linux.intel.com>
CC: kvm@vger.kernel.org, Avi Kivity <avi@redhat.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: VMX: fix tlb flush with invalid root
References: <4C2EEEA2.5090305@cn.fujitsu.com> <201007050852.49001.sheng@linux.intel.com>
In-Reply-To: <201007050852.49001.sheng@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Sheng Yang wrote:
> On Saturday 03 July 2010 16:02:42 Xiao Guangrong wrote:
>> Commit 341d9b535b6c simplify reload logic while entry guest mode, it
>> can avoid unnecessary sync-root if KVM_REQ_MMU_RELOAD and
>> KVM_REQ_MMU_SYNC both set.
> 
> Which commit you are talking about? Can't find 341d9b535b6c...
> 

Please checkout to the 'next' branch.
