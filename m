Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab2DRL45 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 07:56:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20614 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753252Ab2DRL44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 07:56:56 -0400
Message-ID: <4F8EABF7.805@redhat.com>
Date: Wed, 18 Apr 2012 14:56:39 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: zhangyanfei <zhangyanfei@cn.fujitsu.com>
CC: mtosatti@redhat.com, ebiederm@xmission.com, luto@mit.edu,
        joerg.roedel@amd.com, dzickus@redhat.com, paul.gortmaker@windriver.com,
        gregkh@suse.de, ludwig.nussel@suse.de, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH 0/4] Export offsets of VMCS fields as note information
 for kdump
References: <4F84E0DF.8040206@cn.fujitsu.com> <4F8D1F46.3090901@redhat.com> <4F8D4B4C.8070705@cn.fujitsu.com> <4F8D4D1C.4010400@redhat.com> <4F8E6DA5.8030503@cn.fujitsu.com> <4F8E7A5B.5030904@redhat.com> <4F8E8E3D.8040707@cn.fujitsu.com>
In-Reply-To: <4F8E8E3D.8040707@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2012 12:49 PM, zhangyanfei wrote:
> >>
> > 
> > What type of resource?  Can you give an example?
> > 
> Sorry. No concrete example for now.
>
> We are developing this on a conservative policy and I have put the vmcs processing
> in a new module in patch set v2 as you required. The new module is auto-loaded when
> the vmx cpufeature is detected and it depends on module kvm-intel. Loading and unloading
> this module will have no side effect on the running guests.
>
> And one thing I have to stress is that, we can see guest image as crash dump from
> guest machine's view if we have the vmcsinfo, this itself is useful.

Why is it useful?  Without a concrete example, it's hard to justify the
code bloat.

-- 
error compiling committee.c: too many arguments to function

