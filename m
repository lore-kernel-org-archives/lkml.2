Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253Ab0GYIrJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 04:47:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59578 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492Ab0GYIrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 04:47:06 -0400
Message-ID: <4C4BFA03.8020604@redhat.com>
Date: Sun, 25 Jul 2010 11:46:59 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 1/6] KVM: MMU: fix forgot reserved bits check in speculative
 path
References: <4C3FCFD7.5070005@cn.fujitsu.com> <4C464102.8020205@cn.fujitsu.com> <4C473EDB.6030906@redhat.com> <4C479C75.9000501@cn.fujitsu.com>
In-Reply-To: <4C479C75.9000501@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 07/22/2010 04:18 AM, Xiao Guangrong wrote:
>
> Avi Kivity wrote:
>> On 07/21/2010 03:36 AM, Xiao Guangrong wrote:
>>> Xiao Guangrong wrote:
>>>
>>>> In the speculative path, we should check guest pte's reserved bits
>>>> just as
>>>> the real processor does
>>>>
>>>>
>>> Ping......?
>>>
>> Sorry.  All looks good.  I think no change is needed to patch 3, if we
>> agree on this I'll apply it as is.
> Yeah, i agree, thanks, Avi.

Now applied.

-- 
error compiling committee.c: too many arguments to function

