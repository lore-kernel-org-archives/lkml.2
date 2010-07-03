Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512Ab0GCIMg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 04:12:36 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55814 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754202Ab0GCIMe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 04:12:34 -0400
Message-ID: <4C2EF00A.2090406@cn.fujitsu.com>
Date: Sat, 03 Jul 2010 16:08:42 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 4/6] KVM: MMU: prefetch ptes when intercepted guest
 #PF
References: <4C2C9DC0.8050607@cn.fujitsu.com> <4C2C9E45.1040304@cn.fujitsu.com> <20100702165432.GB25969@amt.cnet>
In-Reply-To: <20100702165432.GB25969@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Marcelo Tosatti wrote:

>> +
>> +		if (is_rsvd_bits_set(vcpu, gpte, PT_PAGE_TABLE_LEVEL))
>> +			break;
> 
> BTW, doesnt sync_page also lack reserved bit checking? (unrelated to
> this patch).
> 

I think it's not since if EPT is enabled, no unsync page exist, the sync page
path can't be trigged. :-)
