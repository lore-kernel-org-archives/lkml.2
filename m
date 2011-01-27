Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877Ab1A0Su3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 13:50:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42732 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752681Ab1A0Su2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 13:50:28 -0500
Date: Thu, 27 Jan 2011 13:50:21 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Eric Paris <eparis@parisplace.org>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, Eric Paris <eparis@redhat.com>,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] kexec: include sysctl to disable
Message-ID: <20110127185021.GE23047@redhat.com>
References: <20110119222630.6755.63928.stgit@paris.rdu.redhat.com>
 <ih8gpe$41t$1@dough.gmane.org>
 <ih8he2$41t$2@dough.gmane.org>
 <AANLkTi=LJWvT5r=0rSBxV4aQdm6n2YAS_0y0RkKdTXQp@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=LJWvT5r=0rSBxV4aQdm6n2YAS_0y0RkKdTXQp@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 27, 2011 at 01:40:02PM -0500, Eric Paris wrote:
> Ping, not hearing any argument is usually a good thing   :)
> 

So if we allowing locking down module loading, why not allow locking down
kexec kernel loading, hence...

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Vivek

> -Eric
> 
> On Thu, Jan 20, 2011 at 12:32 AM, WANG Cong <xiyou.wangcong@gmail.com> wrote:
> 
> >> On Wed, 19 Jan 2011 17:26:30 -0500, Eric Paris wrote:
> >>
> >>> much like /proc/sys/kernel/modules_disable is used to disable module
> >>> loading, /proc/sys/kernel/kexec_disable is used to disable kexec code
> >>> loading.  It would still be possible to use kexec -l to load a kernel,
> >>> set the tunable to 1 so the kernel waiting to boot couldn't change, and
> >>> then launch the kernel at a later time (through kexec -e or through a
> >>> crash)
> 
> > Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
