Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134Ab1F2NBc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 09:01:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27726 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009Ab1F2NBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 09:01:30 -0400
Message-ID: <4E0B2220.3050602@redhat.com>
Date: Wed, 29 Jun 2011 16:01:20 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 19/22] KVM: MMU: lockless walking shadow page table
References: <4E01FBC9.3020009@cn.fujitsu.com> <4E01FDB4.60306@cn.fujitsu.com> <4E0AED86.2060908@redhat.com> <4E0B0997.4090206@cn.fujitsu.com> <4E0B09EA.1040304@redhat.com> <4E0B1191.6040100@cn.fujitsu.com> <4E0B182C.1090402@redhat.com> <4E0B1A75.4070705@cn.fujitsu.com> <4E0B1A4E.2030301@redhat.com> <4E0B1CE8.2060803@cn.fujitsu.com>
In-Reply-To: <4E0B1CE8.2060803@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2011 03:39 PM, Xiao Guangrong wrote:
> >
> >  Ok.  Let's drop the two paths, and put this improvement on the TODO instead.
> >
>
> Avi, i am sorry, i do not understand it clearly, it means keep the patch as the
> original way and do the improvement after it merged?

I mean, do all freeing using RCU and improve fork detection after 
merge.  I don't like the extra complexity and the extra atomic ops.

-- 
error compiling committee.c: too many arguments to function

