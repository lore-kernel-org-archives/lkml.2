Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795Ab1GLIjw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 04:39:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26079 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751157Ab1GLIjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 04:39:51 -0400
Message-ID: <4E1C084F.5030107@redhat.com>
Date: Tue, 12 Jul 2011 11:39:43 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 00/18] KVM: optimize for MMIO handled
References: <4E1B4CF8.605@cn.fujitsu.com>
In-Reply-To: <4E1B4CF8.605@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2011 10:20 PM, Xiao Guangrong wrote:
> Changes in this new version:
> - fix the logic of dirty bit in [PATCH 04/19] KVM: MMU: cache
>    mmio info on page fault path
> - rename is_mmio_pfn() to is_noslot_pfn() to avoid the conflicts
>    with kvm_is_mmio_pfn
> - remove [PATCH 14/19] KVM: MMU: clean up spte updating and clearing
> - completely check the last spte for mmio page fault suggested
>    by Marcelo Tosatti

Applied, thanks.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

