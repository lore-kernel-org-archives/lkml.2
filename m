Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284Ab2F0TUo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 15:20:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49521 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755305Ab2F0TUl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 15:20:41 -0400
Message-ID: <1340824837.1207.221.camel@bling.home>
Subject: Re: linux-next: Tree for Jun 27 (vfio)
From: Alex Williamson <alex.williamson@redhat.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Date: Wed, 27 Jun 2012 13:20:37 -0600
In-Reply-To: <4FEB3030.9070900@xenotime.net>
References: <20120627132217.f8bbdd1f467711419123d188@canb.auug.org.au>
	 <4FEB3030.9070900@xenotime.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-27 at 09:09 -0700, Randy Dunlap wrote:
> On 06/26/2012 08:22 PM, Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > This tree was not built between each merge, but only after merging all
> > the trees.
> > 
> > Changes since 20120626:
> > 
> > New tree: vfio
> 
> 
> on x86_64:
> 
>   CC [M]  drivers/vfio/vfio.o
> drivers/vfio/vfio.c: In function 'vfio_device_release':
> drivers/vfio/vfio.c:412:2: error: 'TASK_NORMAL' undeclared (first use in this function)
> drivers/vfio/vfio.c:412:2: note: each undeclared identifier is reported only once for each function it appears in
> drivers/vfio/vfio.c: In function 'vfio_del_group_dev':
> 
> drivers/vfio/vfio.c:695:2: error: 'TASK_UNINTERRUPTIBLE' undeclared (first use in this function)
> drivers/vfio/vfio.c:695:2: error: implicit declaration of function 'schedule'
> *** [drivers/vfio/vfio.o] Error 1
> 
> 
> Full randconfig file is attached.

Thanks for the report, this should be fixed in tomorrow's tree.  Thanks,

Alex

