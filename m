Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188Ab0GMBVb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 21:21:31 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52789 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755551Ab0GMBVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 21:21:30 -0400
Message-ID: <4C3BBEAB.8030608@cn.fujitsu.com>
Date: Tue, 13 Jul 2010 09:17:31 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 5/9] KVM: MMU: introduce gfn_to_page_many_atomic()
 function
References: <4C330918.6040709@cn.fujitsu.com> <4C330A00.50108@cn.fujitsu.com> <4C39C030.6080009@redhat.com> <4C3A8435.4050805@cn.fujitsu.com> <4C3B0A58.5050009@redhat.com>
In-Reply-To: <4C3B0A58.5050009@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Avi Kivity wrote:

>>>      
>> I think it's better that handle the reset pages in the slot, for example,
>> we expect 16 pages are consecutive, but only 12 pages in the slot, the
>> better
>> way is handle the reset 12 pages not throw those away.
> 
> It will almost never happen, let's remove edge cases.
> 

OK, will update it.
 
