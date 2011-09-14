Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230Ab1INJzY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 05:55:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21830 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756057Ab1INJzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 05:55:23 -0400
Message-ID: <4E7079FD.6050506@redhat.com>
Date: Wed, 14 Sep 2011 12:55:09 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 05/11] KVM: MMU: do not mark accessed bit on pte write
 path
References: <4E5C4C20.3000403@cn.fujitsu.com> <4E5C4C8D.5040509@cn.fujitsu.com> <4E6F363E.9080000@redhat.com> <4E6FA117.1050707@cn.fujitsu.com>
In-Reply-To: <4E6FA117.1050707@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2011 09:29 PM, Xiao Guangrong wrote:
> On 09/13/2011 06:53 PM, Avi Kivity wrote:
> >  On 08/30/2011 05:35 AM, Xiao Guangrong wrote:
> >>  In current code, the accessed bit is always set when page fault occurred,
> >>  do not need to set it on pte write path
> >
> >  What about speculative sptes that are then only accessed via emulation?
> >
>
> The gfn is read and written only via emulation? I think this case is very
> very rare?

Probably...

Marcelo? Can you think of another case where spte.accessed is needed?

-- 
error compiling committee.c: too many arguments to function

