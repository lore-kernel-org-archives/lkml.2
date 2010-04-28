Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792Ab0D1LGh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 07:06:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60867 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753367Ab0D1LGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 07:06:36 -0400
Message-ID: <4BD8177D.4010503@redhat.com>
Date: Wed, 28 Apr 2010 19:09:49 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Miles Lane <miles.lane@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>, Len Brown <len.brown@intel.com>,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Amerigo Wang <amwang@redhat.com>
Subject: Re: 2.6.34-rc5-git7 -- INFO: possible circular locking dependency
 detected - &per_cpu(cpu_policy_rwsem, cpu)){+++++.}, at: [<ffffffff8139f077>]
 lock_policy_rwsem_read+0x4a/0x7a
References: <v2sa44ae5cd1004261830wd566507by56131aa9ececb3d@mail.gmail.com> <20100427014136.GA14719@redhat.com>
In-Reply-To: <20100427014136.GA14719@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> On Mon, Apr 26, 2010 at 09:30:41PM -0400, Miles Lane wrote:
>  > Dave, is this the same?   http://marc.info/?l=linux-kernel&m=127207512031810&w=2
> 
> looks like it to me.  499bca9b6d3243f9278a1f5a22d00e67acdd844d should have fixed it,
> but it looks like that's present in -git7, so something is still missing..
> 

Ah, this is almost a totally different bug. I will check it tomorrow.

Thanks!
