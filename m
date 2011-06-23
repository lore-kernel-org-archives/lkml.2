Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384Ab1FWGiq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 02:38:46 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57363 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753653Ab1FWGio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 02:38:44 -0400
Message-ID: <4E02DFE9.901@cn.fujitsu.com>
Date: Thu, 23 Jun 2011 14:40:41 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 21/22] KVM: MMU: mmio page fault support
References: <4E01FBC9.3020009@cn.fujitsu.com> <4E01FDE0.5080800@cn.fujitsu.com> <20110622215940.GA30064@amt.cnet> <4E02B0BE.7070003@cn.fujitsu.com>
In-Reply-To: <4E02B0BE.7070003@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-23 14:38:15,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-23 14:38:15,
	Serialize complete at 2011-06-23 14:38:15
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2011 11:19 AM, Xiao Guangrong wrote:

>> Otherwise you can move the mmio info from an mmio spte back to
>> mmio_gva/mmio_gfn after a TLB flush, without rereading the guest
>> pagetable.
>>
> 
> We do not read the guest page table when mmio page fault occurred,
> we just do it as you say:
> - Firstly, walk the shadow page table to get the mmio spte
> - Then, cache the mmio spte info to mmio_gva/mmio_gfn
> 
> I missed your meaning?
> 

Marcelo, sorry for my poor English, i missed your meaning, please ignore
this. :(
