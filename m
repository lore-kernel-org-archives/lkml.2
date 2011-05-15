Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108Ab1EOInJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 04:43:09 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52967 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754849Ab1EOInH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 04:43:07 -0400
Message-ID: <4DCF9286.8060704@cn.fujitsu.com>
Date: Sun, 15 May 2011 16:44:54 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 5/7] KVM: MMU: remove the arithmetic of parent pte rmap
References: <4DCEF5B1.3050706@cn.fujitsu.com> <4DCEF7C2.401@cn.fujitsu.com> <4DCF8D6B.9080905@redhat.com>
In-Reply-To: <4DCF8D6B.9080905@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-05-15 16:43:16,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-05-15 16:43:16,
	Serialize complete at 2011-05-15 16:43:16
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2011 04:23 PM, Avi Kivity wrote:
> On 05/15/2011 12:44 AM, Xiao Guangrong wrote:
>> Parent pte rmap and page rmap are very similar, so use the same arithmetic for
>> them
>>
> 
> While they're similar, this is going to cause a lot of confusion because the name 'rmap' already has a deep meaning, at least for me.
> 
> Maybe we can call the abstract structure 'spte_list' and define operations on that, then implement rmap_* and *_parent_pte as wrappers around spte_list.
> 

OK, will fix the confused name in next version, thanks!
