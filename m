Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207Ab1JKIeO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 04:34:14 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56469 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751949Ab1JKIeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 04:34:11 -0400
Message-ID: <4E940018.1010908@cn.fujitsu.com>
Date: Tue, 11 Oct 2011 16:36:40 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 00/11] KVM: x86: optimize for writing guest page
References: <4E7AF758.7060900@cn.fujitsu.com> <20111006175333.GA3959@amt.cnet> <4E8FCC37.8090409@cn.fujitsu.com> <4E91926D.8060206@redhat.com> <4E91A3AA.1000309@redhat.com>
In-Reply-To: <4E91A3AA.1000309@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-10-11 16:32:30,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-10-11 16:32:30,
	Serialize complete at 2011-10-11 16:32:30
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2011 09:37 PM, Avi Kivity wrote:
> On 10/09/2011 02:24 PM, Avi Kivity wrote:
>> On 10/08/2011 06:06 AM, Xiao Guangrong wrote:
>>> On 10/07/2011 01:53 AM, Marcelo Tosatti wrote:
>>> >  On Thu, Sep 22, 2011 at 04:52:40PM +0800, Xiao Guangrong wrote:
>>> >>  This patchset is against https://github.com/avikivity/kvm.git next branch.
>>> >>
>>> >>  In this version, some changes come from Avi's comments:
>>> >>  - fix instruction retried for nested guest
>>> >>  - skip write-flooding for the sp whose level is 1
>>> >>  - rename some functions
>>> >
>>> >  Please rebase.
>>> >
>>> >
>>>
>>> Marcelo,
>>>
>>> These patches can be applied without any conflict and it also works well,
>>> the current code was pulled from https://github.com/avikivity/kvm.git next branch.
>>>
>>> What problem did you meet when you applied these? :(
>>
>> I guess it was a user error - it applies cleanly here too (and pushed to next, thanks).
>>
> 
> However, it seems to reduce performance.
> 

Ouch, will look into it soon.
