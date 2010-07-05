Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856Ab0GEIAR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 04:00:17 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57278 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752563Ab0GEIAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 04:00:12 -0400
Message-ID: <4C319024.9050300@cn.fujitsu.com>
Date: Mon, 05 Jul 2010 15:56:20 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>,
       Jin Dongming <jin.dongming@np.css.fujitsu.com>
Subject: Re: [PATCH v2] KVM: IOAPIC: only access APIC registers one dword
 at a time
References: <4C2D6D4B.5060309@cn.fujitsu.com> <4C2D95EA.6080209@np.css.fujitsu.com> <4C2D975A.2050704@cn.fujitsu.com> <4C2D9C8C.8060401@cn.fujitsu.com> <4C2F0CC1.6020808@redhat.com> <4C3155BA.4070903@cn.fujitsu.com> <4C318FAC.8010605@redhat.com>
In-Reply-To: <4C318FAC.8010605@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Avi Kivity wrote:

> 
>>> There might be guests that use incorrect access despite the
>>> documentation; if real hardware supports it, it should work.  So we need
>>> to start with just a warning, and allow the access.  Later we can drop
>>> the invalid access.
>>>      
>> If the OS contravene the spec, i thinks it's the OS's bug, also, i
>> have tested some versions
>> windows/linux guests, it's no broken, can we directly drop the other
>> wide access?
>>    
> 
> Well, there's the spec and there's real life, but in this case we can
> try and if we see a problem we'll re-add the other access length.
> 

OK, i'll do it as your suggestion, thanks.
