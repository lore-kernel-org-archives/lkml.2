Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600Ab0LJPFJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 10:05:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51992 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753572Ab0LJPFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 10:05:08 -0500
Date: Fri, 10 Dec 2010 16:05:06 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trivial: fix typos concerning "consistent"
In-Reply-To: <1291989342-15763-1-git-send-email-u.kleine-koenig@pengutronix.de>
Message-ID: <alpine.LNX.2.00.1012101604350.15140@pobox.suse.cz>
References: <1291989342-15763-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Dec 2010, Uwe Kleine-König wrote:

> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
>  arch/arm/mach-msm/include/mach/entry-macro-qgic.S  |    2 +-
>  arch/m68k/mac/psc.c                                |    2 +-
>  drivers/net/via-velocity.c                         |    2 +-
>  drivers/net/wimax/i2400m/i2400m.h                  |    2 +-
>  drivers/scsi/megaraid/megaraid_mm.c                |    2 +-
>  drivers/staging/cxt1e1/hwprobe.c                   |    2 +-
>  drivers/staging/cxt1e1/pmcc4.h                     |    2 +-
>  drivers/staging/cxt1e1/pmcc4_drv.c                 |    2 +-
>  .../staging/tidspbridge/include/dspbridge/drv.h    |    2 +-
>  fs/jbd/transaction.c                               |    2 +-
>  fs/jbd2/transaction.c                              |    2 +-
>  net/ipv6/af_inet6.c                                |    2 +-
>  12 files changed, 12 insertions(+), 12 deletions(-)

I have separated out the staging bits (please submit those to Greg), and 
applied the rest.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
