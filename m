Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760136Ab0I1JEG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 05:04:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4523 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753284Ab0I1JEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 05:04:04 -0400
Message-ID: <4CA1AF7E.40104@redhat.com>
Date: Tue, 28 Sep 2010 11:03:58 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/7] KVM: MMU: update 'root_hpa' out of loop in PAE shadow
 path
References: <4CA06BA4.4090303@cn.fujitsu.com> <4CA06E9C.9060401@cn.fujitsu.com> <4CA0AC99.8000705@redhat.com> <4CA15634.50300@cn.fujitsu.com>
In-Reply-To: <4CA15634.50300@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 09/28/2010 04:43 AM, Xiao Guangrong wrote:
> On 09/27/2010 10:39 PM, Avi Kivity wrote:
> >   On 09/27/2010 12:14 PM, Xiao Guangrong wrote:
> >>  On 09/27/2010 06:02 PM, Xiao Guangrong wrote:
> >>  >   The value of 'vcpu->arch.mmu.pae_root' is not modified, so we can
> >>  update 'root_hpa'
> >>  >   out of the loop
> >>  >
> >>  >   Xiao Guangrong<xiaoguangrong@cn.fujitsu.com>
> >>
> >>  Hi Avi, Marcelo,
> >>
> >>  I'm so sorry that missed "Signed-off-by: " string in all patches, i'll
> >>  repost this
> >>  patchset after your review. :-(
> >
> >  I fixed up the signoffs and applied.
>
> Thanks Avi.
>
> I noticed you applied "KVM: MMU: rename 'sp->root_count' to 'sp->active_count'"
> (commit 55d80c448e7e3417) instead of this patch :-)

Thanks for noticing!  Fixed.

No idea how it happened.

-- 
error compiling committee.c: too many arguments to function

