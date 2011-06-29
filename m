Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161Ab1F2NDm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 09:03:42 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64540 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755535Ab1F2NDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 09:03:40 -0400
Message-ID: <4E0B231B.4070808@cn.fujitsu.com>
Date: Wed, 29 Jun 2011 21:05:31 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 19/22] KVM: MMU: lockless walking shadow page table
References: <4E01FBC9.3020009@cn.fujitsu.com> <4E01FDB4.60306@cn.fujitsu.com> <4E0AED86.2060908@redhat.com> <4E0B0997.4090206@cn.fujitsu.com> <4E0B09EA.1040304@redhat.com> <4E0B1191.6040100@cn.fujitsu.com> <4E0B182C.1090402@redhat.com> <4E0B1A75.4070705@cn.fujitsu.com> <4E0B1A4E.2030301@redhat.com> <4E0B1CE8.2060803@cn.fujitsu.com> <4E0B2220.3050602@redhat.com>
In-Reply-To: <4E0B2220.3050602@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-29 21:03:01,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-29 21:03:02,
	Serialize complete at 2011-06-29 21:03:02
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2011 09:01 PM, Avi Kivity wrote:
> On 06/29/2011 03:39 PM, Xiao Guangrong wrote:
>> >
>> >  Ok.  Let's drop the two paths, and put this improvement on the TODO instead.
>> >
>>
>> Avi, i am sorry, i do not understand it clearly, it means keep the patch as the
>> original way and do the improvement after it merged?
> 
> I mean, do all freeing using RCU and improve fork detection after merge.  I don't like the extra complexity and the extra atomic ops.
> 

Oh, i see, thanks! :-)
