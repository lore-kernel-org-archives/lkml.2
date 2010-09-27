Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305Ab0I0KQW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 06:16:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43987 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905Ab0I0KQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 06:16:20 -0400
Message-ID: <4CA06EED.2070200@redhat.com>
Date: Mon, 27 Sep 2010 12:16:13 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/7] KVM: MMU: update 'root_hpa' out of loop in PAE shadow
 path
References: <4CA06BA4.4090303@cn.fujitsu.com> <4CA06E9C.9060401@cn.fujitsu.com>
In-Reply-To: <4CA06E9C.9060401@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 09/27/2010 12:14 PM, Xiao Guangrong wrote:
> On 09/27/2010 06:02 PM, Xiao Guangrong wrote:
> >  The value of 'vcpu->arch.mmu.pae_root' is not modified, so we can update 'root_hpa'
> >  out of the loop
> >
> >  Xiao Guangrong<xiaoguangrong@cn.fujitsu.com>
>
> Hi Avi, Marcelo,
>
> I'm so sorry that missed "Signed-off-by: " string in all patches, i'll repost this
> patchset after your review. :-(

I use 'git commit -s' to simplify adding signoffs.

-- 
error compiling committee.c: too many arguments to function

