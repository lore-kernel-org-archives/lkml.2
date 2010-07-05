Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757455Ab0GEIZP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 04:25:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17535 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757040Ab0GEIZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 04:25:13 -0400
Message-ID: <4C3196E2.4090809@redhat.com>
Date: Mon, 05 Jul 2010 11:25:06 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>,
       Jin Dongming <jin.dongming@np.css.fujitsu.com>
Subject: Re: [PATCH v2] KVM: IOAPIC: only access APIC registers one dword
 at a time
References: <4C2D6D4B.5060309@cn.fujitsu.com> <4C2D95EA.6080209@np.css.fujitsu.com> <4C2D975A.2050704@cn.fujitsu.com> <4C2D9C8C.8060401@cn.fujitsu.com> <4C2F0CC1.6020808@redhat.com> <4C3155BA.4070903@cn.fujitsu.com> <4C318FAC.8010605@redhat.com> <4C319024.9050300@cn.fujitsu.com>
In-Reply-To: <4C319024.9050300@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2010 10:56 AM, Xiao Guangrong wrote:
>
>> Well, there's the spec and there's real life, but in this case we can
>> try and if we see a problem we'll re-add the other access length.
>>
>>      
> OK, i'll do it as your suggestion, thanks.
>    

I meant that you can drop access length != 4, same as in your original 
patch.  Only change needed is printk rate limit.

-- 
error compiling committee.c: too many arguments to function

