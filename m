Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756887Ab0GVBWw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 21:22:52 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52291 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751775Ab0GVBWv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 21:22:51 -0400
Message-ID: <4C479C75.9000501@cn.fujitsu.com>
Date: Thu, 22 Jul 2010 09:18:45 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 1/6] KVM: MMU: fix forgot reserved bits check in speculative
 path
References: <4C3FCFD7.5070005@cn.fujitsu.com> <4C464102.8020205@cn.fujitsu.com> <4C473EDB.6030906@redhat.com>
In-Reply-To: <4C473EDB.6030906@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Avi Kivity wrote:
> On 07/21/2010 03:36 AM, Xiao Guangrong wrote:
>>
>> Xiao Guangrong wrote:
>>   
>>> In the speculative path, we should check guest pte's reserved bits
>>> just as
>>> the real processor does
>>>
>>>      
>> Ping......?
>>    
> 
> Sorry.  All looks good.  I think no change is needed to patch 3, if we
> agree on this I'll apply it as is.

Yeah, i agree, thanks, Avi.
