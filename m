Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759381Ab1FXOxk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 10:53:40 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:58746 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057Ab1FXOxh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 10:53:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qekAAsZls/tLuw3QNWnVZqYVcDuMFCzWpPCjsAp6LbI99HvlxIwhtESDk60//xo1vW
         zU3cNKsjErK3IMqq6o4n4DxFKtWaZlk4BXQuaV5CS5rbxPDj/Mv5S8Hjv0jAcAuFgibB
         azfJDztOAOrN5bjEMERh2q2eoX+FRrHwZCuZU=
MIME-Version: 1.0
In-Reply-To: <4E0488A9.6050109@imgtec.com>
References: <4E0488A9.6050109@imgtec.com>
Date: Fri, 24 Jun 2011 15:53:36 +0100
Message-ID: <BANLkTi=0Xg_w54ZaUPeb9e+A-_pcTjTg+w@mail.gmail.com>
Subject: Re: [PATCH 0/6] mmc: dw_mmc: misc fixes and improvements
From: Will Newton <will.newton@gmail.com>
To: James Hogan <james.hogan@imgtec.com>
Cc: Chris Ball <cjb@laptop.org>, Will Newton <will.newton@imgtec.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Matt Fleming <matt@console-pimps.org>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, james@albanarts.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 24, 2011 at 1:52 PM, James Hogan <james.hogan@imgtec.com> wrote:
> Misc improvements and fixes for the Synopsys DesignWare MMC driver:
>
> [PATCH 1/6] mmc: dw_mmc: clear TXDR/RXDR ints before enabling
>        fixes a failure to probe the next card after an unplug
> [PATCH 2/6] mmc: dw_mmc: fix race with request and removal
>        improves spinlock protection
> [PATCH 3/6] mmc: dw_mmc: convert card tasklet to workqueue
>        to allow platform callbacks to sleep
> [PATCH 4/6] mmc: dw_mmc: brackets in register access macros
>        just a small tidyup patch
> [PATCH 5/6] mmc: dw_mmc: don't hard code fifo depth, fix usage
>        improve detection of fifo depth
> [PATCH 6/6] mmc: dw_mmc: handle unaligned buffers and sizes
>        fix some mmc_test failures wrt unaligned buffer/sizes
>
>  drivers/mmc/host/dw_mmc.c  |  398 ++++++++++++++++++++++++++++++++++----------
>  drivers/mmc/host/dw_mmc.h  |   17 +-
>  include/linux/mmc/dw_mmc.h |   20 ++-
>  3 files changed, 340 insertions(+), 95 deletions(-)

All these patches:

Acked-by: Will Newton <will.newton@imgtec.com>
