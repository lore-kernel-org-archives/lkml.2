Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763Ab1GFTLa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 15:11:30 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52973 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755704Ab1GFTL3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 15:11:29 -0400
Message-ID: <4E14B3D3.60301@cn.fujitsu.com>
Date: Thu, 07 Jul 2011 03:13:23 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 11/19] KVM: MMU: filter out the mmio pfn from the fault
 pfn
References: <4E0C3178.2080603@cn.fujitsu.com> <4E0C32A6.6080607@cn.fujitsu.com> <20110706171734.GD24417@amt.cnet>
In-Reply-To: <20110706171734.GD24417@amt.cnet>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-07 03:10:47,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-07 03:10:48,
	Serialize complete at 2011-07-07 03:10:48
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/2011 01:17 AM, Marcelo Tosatti wrote:
 
>> +int is_mmio_pfn(pfn_t pfn)
>> +{
>> +	return pfn == bad_pfn;
>> +}
>> +EXPORT_SYMBOL_GPL(is_mmio_pfn);
> 
> Please use another name this conflicts with real mmio pfn,
> see kvm_is_mmio_pfn. "noslot_pfn" is meaningful to me.
> 

OK, will fix, thanks!

