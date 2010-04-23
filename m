Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197Ab0DWN3A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 09:29:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6563 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755814Ab0DWN27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 09:28:59 -0400
Message-ID: <4BD1A03D.4000008@redhat.com>
Date: Fri, 23 Apr 2010 16:27:25 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/10] KVM MMU: Move invlpg code out of paging_tmpl.h
References: <4BCFE3D5.5070105@cn.fujitsu.com> <4BCFE8E2.8080302@cn.fujitsu.com> <4BD18410.6030509@redhat.com> <4BD187CB.5090701@redhat.com> <4BD19EEC.1030205@cn.fujitsu.com>
In-Reply-To: <4BD19EEC.1030205@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2010 04:21 PM, Xiao Guangrong wrote:
>
> OK, i'll keep invlpg code in paging_tmpl.h and directly call FNAME(update_pte).
>
> But, i don't see mmu_guess_page_from_pte_write() code depends on pte size. :-(
>    

It doesn't indeed, I misremembered.  It's mmu_pte_write_new_pte() (which 
is no longer needed).

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

