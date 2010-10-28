Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880Ab0J1JFb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 05:05:31 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57790 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751516Ab0J1JFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 05:05:30 -0400
Message-ID: <4CC93DE1.1060700@cn.fujitsu.com>
Date: Thu, 28 Oct 2010 17:09:53 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 8/8] KVM: add debugfs file to show the number of async
 pf
References: <4CC7EA7D.5020901@cn.fujitsu.com> <4CC7EC9B.6020507@cn.fujitsu.com> <20101027105849.GQ26191@redhat.com>
In-Reply-To: <20101027105849.GQ26191@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2010 06:58 PM, Gleb Natapov wrote:
> On Wed, Oct 27, 2010 at 05:10:51PM +0800, Xiao Guangrong wrote:
>> It can help us to see the state of async pf
>>
> I have patch to add three async pf statistics:
> apf_not_present
> apf_present
> apf_doublefault
> 
> But Avi now wants to deprecate debugfs interface completely and move
> towards ftrace, so I had to drop it.
> 

OK, let's ignore this patch, thanks :-) 
