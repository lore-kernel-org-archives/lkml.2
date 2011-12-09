Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999Ab1LIQ53 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 11:57:29 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:33845 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929Ab1LIQ52 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 11:57:28 -0500
MIME-Version: 1.0
In-Reply-To: <38c134f7b555bf732550884366991391d35bb229.1323401278.git.joe@perches.com>
References: <cover.1323401278.git.joe@perches.com>
	<38c134f7b555bf732550884366991391d35bb229.1323401278.git.joe@perches.com>
Date: Fri, 9 Dec 2011 08:57:27 -0800
X-Google-Sender-Auth: Ese2naDPqHbJwTyhpQI9XzILs0I
Message-ID: <CANEJEGv7JcfrSntT8Aq72=W5gf2C4MpemQJTXQQ=JrzDjYRO0Q@mail.gmail.com>
Subject: Re: [PATCH v3.2 08/10] MAINTAINERS: Update tulip F: patterns
From: Grant Grundler <grantgrundler@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Tobias Ringstrom <tori@unhappy.mine.nu>,
        Grant Grundler <grundler@parisc-linux.org>,
        David Davies <davies@maniac.ultranet.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 8, 2011 at 8:21 PM, Joe Perches <joe@perches.com> wrote:
> commit a88394cfb58 ("ewrk3/tulip: Move the DEC - Tulip drivers")
> moved the files, update the patterns.
>
> CC: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> CC: Tobias Ringstrom <tori@unhappy.mine.nu>
> CC: Grant Grundler <grundler@parisc-linux.org>
> CC: David Davies <davies@maniac.ultranet.com>
>
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Grant Grundler <grundler@parisc-linux.org>

thanks!
grant

> ---
>  MAINTAINERS |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index d7a279f..9926225 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2115,7 +2115,7 @@ DAVICOM FAST ETHERNET (DMFE) NETWORK DRIVER
>  L:     netdev@vger.kernel.org
>  S:     Orphan
>  F:     Documentation/networking/dmfe.txt
> -F:     drivers/net/ethernet/tulip/dmfe.c
> +F:     drivers/net/ethernet/dec/tulip/dmfe.c
>
>  DC390/AM53C974 SCSI driver
>  M:     Kurt Garloff <garloff@suse.de>
> @@ -6655,7 +6655,7 @@ TULIP NETWORK DRIVERS
>  M:     Grant Grundler <grundler@parisc-linux.org>
>  L:     netdev@vger.kernel.org
>  S:     Maintained
> -F:     drivers/net/ethernet/tulip/
> +F:     drivers/net/ethernet/dec/tulip/
>
>  TUN/TAP driver
>  M:     Maxim Krasnyansky <maxk@qualcomm.com>
> --
> 1.7.8.111.gad25c.dirty
>
