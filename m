Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306Ab1G0KDQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 06:03:16 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61125 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751175Ab1G0KDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 06:03:15 -0400
Message-ID: <4E2FE2DA.9040209@cn.fujitsu.com>
Date: Wed, 27 Jul 2011 18:05:14 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 09/11] KVM: MMU: remove the mismatch shadow page
References: <4E2EA3DB.7040403@cn.fujitsu.com> <4E2EA58B.1030503@cn.fujitsu.com> <4E2FD65C.9000402@redhat.com> <4E2FD6AD.5010902@redhat.com>
In-Reply-To: <4E2FD6AD.5010902@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-27 18:02:19,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-27 18:02:20,
	Serialize complete at 2011-07-27 18:02:20
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2011 05:13 PM, Avi Kivity wrote:
> On 07/27/2011 12:11 PM, Avi Kivity wrote:
>> On 07/26/2011 02:31 PM, Xiao Guangrong wrote:
>>> If the shadow page has different cpu mode with current vcpu, we do better
>>> remove them since the OS does not changes cpu mode frequently
>>>
>>
>> This is true
> 
> It's actually not true.  With nested virtualization the cpu changes modes all the time.
> 

Oh, yes, i forgot this, thanks point it out!

