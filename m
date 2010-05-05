Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934208Ab0EEMTo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 08:19:44 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58415 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932090Ab0EEMTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 08:19:42 -0400
Message-ID: <4BE161A0.4000007@cn.fujitsu.com>
Date: Wed, 05 May 2010 20:16:32 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 7/10] KVM MMU: allow more page become unsync at gfn
 mapping time
References: <4BD7AE34.5000408@cn.fujitsu.com> <4BD7B1C5.10808@cn.fujitsu.com> <20100430193325.GA6023@amt.cnet>
In-Reply-To: <20100430193325.GA6023@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Marcelo Tosatti wrote:
> On Wed, Apr 28, 2010 at 11:55:49AM +0800, Xiao Guangrong wrote:
>> In current code, shadow page can become asynchronous only if one
>> shadow page for a gfn, this rule is too strict, in fact, we can
>> let all last mapping page(i.e, it's the pte page) become unsync,
>> and sync them at invlpg or flush tlb time.
>>
>> This patch allow more page become asynchronous at gfn mapping time 
>>
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> 
> Xiao,
> 
> This patch breaks Fedora 8 32 install. Reverted patches 5-10.

Hi Marcelo,

Sorry for the delay reply since i'm on holiday.

I have found the reason of this issue, two fix patches will be sent soon,
could you please try it?

Thanks,
Xiao
