Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760451Ab2D0RDw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 13:03:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43300 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127Ab2D0RDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 13:03:51 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] spi: fix spi.h kernel-doc warning
To: Randy Dunlap <rdunlap@xenotime.net>, LKML <linux-kernel@vger.kernel.org>,
        spi-devel-general@lists.sourceforge.net
In-Reply-To: <4F8E04E6.60005@xenotime.net>
References: <4F8E04E6.60005@xenotime.net>
Date: Fri, 27 Apr 2012 11:03:47 -0600
Message-Id: <20120427170347.BEA843E0B4D@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Apr 2012 17:03:50 -0700, Randy Dunlap <rdunlap@xenotime.net> wrote:
> From: Randy Dunlap <rdunlap@xenotime.net>
> 
> Fix kernel-doc warning in spi.h (copy/pasto):
> 
> Warning(include/linux/spi/spi.h:365): No description found for parameter 'unprepare_transfer_hardware'
> 
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>

Applied, thanks.

g.

> ---
>  include/linux/spi/spi.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- lnx-34-rc3.orig/include/linux/spi/spi.h
> +++ lnx-34-rc3/include/linux/spi/spi.h
> @@ -254,7 +254,7 @@ static inline void spi_unregister_driver
>   *	driver is finished with this message, it must call
>   *	spi_finalize_current_message() so the subsystem can issue the next
>   *	transfer
> - * @prepare_transfer_hardware: there are currently no more messages on the
> + * @unprepare_transfer_hardware: there are currently no more messages on the
>   *	queue so the subsystem notifies the driver that it may relax the
>   *	hardware by issuing this call
>   *

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
