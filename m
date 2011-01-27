Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882Ab1A0S4n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 13:56:43 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40324 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967Ab1A0S4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 13:56:42 -0500
Date: Thu, 27 Jan 2011 13:56:27 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Eric Paris <eparis@parisplace.org>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, Eric Paris <eparis@redhat.com>,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] kexec: include sysctl to disable
Message-ID: <20110127185627.GA3455@shamino.rdu.redhat.com>
References: <20110119222630.6755.63928.stgit@paris.rdu.redhat.com>
 <ih8gpe$41t$1@dough.gmane.org>
 <ih8he2$41t$2@dough.gmane.org>
 <AANLkTi=LJWvT5r=0rSBxV4aQdm6n2YAS_0y0RkKdTXQp@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=LJWvT5r=0rSBxV4aQdm6n2YAS_0y0RkKdTXQp@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Spam-Score: -3.8 (---)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 27, 2011 at 01:40:02PM -0500, Eric Paris wrote:
> Ping, not hearing any argument is usually a good thing   :)
> 
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
> 
Acked-by: Neil Horman <nhorman@tuxdriver.com>

> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec
> 
