Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab0CVNku (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 09:40:50 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:40792 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754483Ab0CVNkt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 09:40:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=gX/5Varro64t+okygqhc4QqEZcEWsVQ6O3gCRotD70Hi9wqmuI0TYIP1Zl4ond/DQw
         hMFZ02Ml28M16gyIqnzc+XZmQzE8vStDe7aBbFkWcLzZdUqEjhdIZgkoAz0EMhqwd6m6
         6wMoBS/Z8s2+60Snj+lTDFxJsl9QTh4J/uWz4=
MIME-Version: 1.0
In-Reply-To: <20100322115244.GA10368@zooey>
References: <20100322115244.GA10368@zooey>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Mon, 22 Mar 2010 14:40:27 +0100
Message-ID: <69e28c911003220640t77d01dccod8232ea007257a5f@mail.gmail.com>
Subject: Re: [PATCH] drivers/net/wireless/b43/main.c:4351: Fixed coding style
To: Daniel Ngu <daniel.dy.ngu@gmail.com>
Cc: Stefano Brivio <stefano.brivio@polimi.it>, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 22, 2010 at 12:52 PM, Daniel Ngu <daniel.dy.ngu@gmail.com> wrote:
> WARNING: braces {} are not necessary for any arm of this statement
>
> Signed-off-by: Daniel Ngu <daniel.dy.ngu@gmail.com>
> ---
>  drivers/net/wireless/b43/main.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
> index 1521b1e..14cf3bd 100644
> --- a/drivers/net/wireless/b43/main.c
> +++ b/drivers/net/wireless/b43/main.c
> @@ -4348,11 +4348,10 @@ static int b43_wireless_core_init(struct b43_wldev *dev)
>        b43_set_phytxctl_defaults(dev);
>
>        /* Minimum Contention Window */
> -       if (phy->type == B43_PHYTYPE_B) {
> +       if (phy->type == B43_PHYTYPE_B)
>                b43_shm_write16(dev, B43_SHM_SCRATCH, B43_SHM_SC_MINCONT, 0x1F);
> -       } else {
> +       else
>                b43_shm_write16(dev, B43_SHM_SCRATCH, B43_SHM_SC_MINCONT, 0xF);
> -       }
>        /* Maximum Contention Window */
>        b43_shm_write16(dev, B43_SHM_SCRATCH, B43_SHM_SC_MAXCONT, 0x3FF);
>
> --
> 1.5.6.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Actually I believe the entire PHYTYPE_B brahcn could be removed, as we
no longer have B-PHY support in b43 anyway. But consult Michael about
this.

--
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
