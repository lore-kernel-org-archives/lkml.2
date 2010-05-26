Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757205Ab0EZKPv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 06:15:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11451 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752884Ab0EZKPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 06:15:49 -0400
Message-ID: <4BFCF4D1.2020501@redhat.com>
Date: Wed, 26 May 2010 13:15:45 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       kvm@vger.kernel.org
Subject: Re: [RESEND PATCH 2/3]  kvm, tdp: calculate correct base gfn for
 non-DIR level
References: <4BD8228D.7090708@cn.fujitsu.com> <20100429180955.GA17909@amt.cnet> <4BD9D35C.5090403@redhat.com> <20100430154427.GA32340@amt.cnet> <4BE269D4.9090108@cn.fujitsu.com> <20100506190402.GA3432@amt.cnet> <4BFCE059.60502@cn.fujitsu.com>
In-Reply-To: <4BFCE059.60502@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2010 11:48 AM, Lai Jiangshan wrote:
> In Document/kvm/mmu.txt:
>    gfn:
>      Either the guest page table containing the translations shadowed by this
>      page, or the base page frame for linear translations. See role.direct.
>
> But in __direct_map(), the base gfn calculation is incorrect,
> it does not calculate correctly when level=3 or 4.
>    

Applied, thanks.

-- 
error compiling committee.c: too many arguments to function

