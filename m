Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab1HWBsK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 21:48:10 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58401 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752888Ab1HWBsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 21:48:09 -0400
Message-ID: <4E530755.1020609@cn.fujitsu.com>
Date: Tue, 23 Aug 2011 09:50:13 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 07/11] KVM: MMU: fast prefetch spte on invlpg path
References: <4E4A10E8.5090705@cn.fujitsu.com> <4E4A11DA.3050605@cn.fujitsu.com> <20110822222854.GA2497@amt.cnet>
In-Reply-To: <20110822222854.GA2497@amt.cnet>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-23 09:47:05,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-23 09:47:07,
	Serialize complete at 2011-08-23 09:47:07
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2011 06:28 AM, Marcelo Tosatti wrote:

>> +
>> +			if (rmap_can_add(vcpu))
>> +				break;
> 
> if (!rmap_can_add(vcpu))
>         break;
> 
> ?
> 

Oh, oops, thanks for you point it out. Will fix it.
