Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639Ab1FUNbH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 09:31:07 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:61741 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394Ab1FUNbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 09:31:04 -0400
Date: Tue, 21 Jun 2011 09:30:50 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] xen: prepare tmem shim to handle frontswap
Message-ID: <20110621133050.GC5650@dumpdata.com>
References: <b9f0ec1d-0dd7-43e5-8c24-26979ae4245c@default>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9f0ec1d-0dd7-43e5-8c24-26979ae4245c@default>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090207.4E009D15.006D:SCFSTAT5015188,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 17, 2011 at 03:00:55PM -0700, Dan Magenheimer wrote:
> Hi Konrad --
> 
> Please pull the following branch into your Xen for-linus tree
> for the upcoming 3.1 window.

Pulled. Stuck it in stable/drivers.
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/djm/tmem.git stable/frontswap-tmemonly
> 
> The branch is based off of 3.0-rc1.
> 
> This single commit provides the shim code for frontswap for Xen
> tmem (even though the core kernel frontswap patchset is not present
> yet... the egg is before the chicken here.)
> 
> Diffstat:
>  drivers/xen/Kconfig                      |    7 
>  drivers/xen/Makefile                     |    2 
>  drivers/xen/tmem.c                       |  170 +++++++++++++++++++--
>  3 files changed, 166 insertions(+), 13 deletions(-
> 
> Dan Magenheimer (1):
>       xen: prepare tmem shim to handle frontswap
> 
> Thanks,
> Dan
