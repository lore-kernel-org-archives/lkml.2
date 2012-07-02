Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682Ab2GBJKg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 05:10:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23122 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753277Ab2GBJKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 05:10:34 -0400
Message-ID: <4FF1657E.4090104@redhat.com>
Date: Mon, 02 Jul 2012 12:10:22 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
CC: mtosatti@redhat.com, agraf@suse.de, paulus@samba.org, aarcange@redhat.com,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linux-kernel@vger.kernel.org, takuya.yoshikawa@gmail.com
Subject: Re: [PATCH 0/8] KVM: Optimize MMU notifier's THP page invalidation
 -v4
References: <20120702175239.5fec56b3.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <20120702175239.5fec56b3.yoshikawa.takuya@oss.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2012 11:52 AM, Takuya Yoshikawa wrote:
> v3->v4: Resolved trace_kvm_age_page() issue -- patch 6,7
> v2->v3: Fixed intersection calculations. -- patch 3, 8
> 
> 	Takuya
> 
> Takuya Yoshikawa (8):
>   KVM: MMU: Use __gfn_to_rmap() to clean up kvm_handle_hva()
>   KVM: Introduce hva_to_gfn_memslot() for kvm_handle_hva()
>   KVM: MMU: Make kvm_handle_hva() handle range of addresses
>   KVM: Introduce kvm_unmap_hva_range() for kvm_mmu_notifier_invalidate_range_start()
>   KVM: Separate rmap_pde from kvm_lpage_info->write_count
>   KVM: MMU: Add memslot parameter to hva handlers
>   KVM: MMU: Push trace_kvm_age_page() into kvm_age_rmapp()
>   KVM: MMU: Avoid handling same rmap_pde in kvm_handle_hva_range()
> 

Reviewed-by: Avi Kivity <avi@redhat.com>


-- 
error compiling committee.c: too many arguments to function


