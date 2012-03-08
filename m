Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638Ab2CHJAw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 04:00:52 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:3109 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755162Ab2CHJAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 04:00:50 -0500
X-IronPort-AV: E=Sophos;i="4.73,551,1325433600"; 
   d="scan'208";a="4489399"
Message-ID: <4F5875F6.9010804@cn.fujitsu.com>
Date: Thu, 08 Mar 2012 17:03:50 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Kay Sievers <kay.sievers@vrfy.org>, Hugh Dickins <hughd@google.com>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH v2 0/3] cgroup: add xattr support
References: <4F4F1459.4080300@cn.fujitsu.com> <20120304180516.GB20787@dhcp-172-17-108-109.mtv.corp.google.com>
In-Reply-To: <20120304180516.GB20787@dhcp-172-17-108-109.mtv.corp.google.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-08 16:58:50,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-08 16:58:53,
	Serialize complete at 2012-03-08 16:58:53
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Hello, Li.
> 
> Sorry about the delay.  Was on vacation.
> 

Me too. ;)

> On Thu, Mar 01, 2012 at 02:16:57PM +0800, Li Zefan wrote:
>> This can be used to attach metadata to a cgroup, which is required
>> by systemd.
>>
>> As lazy as I am, here just quoted from Lennart for the detailed use
>> cases:
> 
> I much prefer this version but would prefer to deal with this in the
> next merge window as we're already on rc6.  On a cursory look...
> 

I'm fine with this, especially I'm busy with other stuff.

> * I'm not sure kmem_ is a good prefix.  It sucks that xattr values are
>   stored in kmem w/o size limit and we probably want to improve on
>   both fronts in the future.  Wouldn't it be better to name them
>   simple_*() and put them in fs/libfs.c?
> 

Ok.

> * I don't think we want CONFIG option for cgroupfs xattr.  Let's just
>   add a mount option.

Ok.

> 
> Thanks.
> 
