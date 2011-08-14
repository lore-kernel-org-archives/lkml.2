Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751236Ab1HNXSZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 19:18:25 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:65395 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091Ab1HNXSX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 19:18:23 -0400
MIME-Version: 1.0
In-Reply-To: <20110811142749.GA26109@maxin>
References: <20110811142749.GA26109@maxin>
Date: Mon, 15 Aug 2011 02:18:22 +0300
Message-ID: <CAMhs6Yy_O33jZ5N7E5UuAtjoRyyEcUG8s4-PQwooX-TJ3Wh=2A@mail.gmail.com>
Subject: Re: [PATCH] SCSI: OSD: Kconfig: Select SHA1 and HMAC for OSD
 Initiator library
From: Maxin B John <maxin.john@gmail.com>
To: rdunlap@xenotime.net
Cc: Boaz Harrosh <bharrosh@panasas.com>, Benny Halevy <bhalevy@panasas.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        osd-dev@open-osd.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping..

On Thu, Aug 11, 2011 at 5:27 PM, Maxin B. John <maxin.john@gmail.com> wrote:
> SCSI_OSD_INITIATOR should select CRYPTO_SHA1 and CRYPTO_HMAC. Express this
> in Kconfig so that the requirements are met automatically.
>
> Signed-off-by: Maxin B. John <maxin.john@gmail.com>
> ---
> diff --git a/drivers/scsi/osd/Kconfig b/drivers/scsi/osd/Kconfig
> index 861b5ce..1535fe1 100644
> --- a/drivers/scsi/osd/Kconfig
> +++ b/drivers/scsi/osd/Kconfig
> @@ -11,17 +11,16 @@
>  # it under the terms of the GNU General Public version 2 License as
>  # published by the Free Software Foundation
>  #
> -# FIXME: SCSI_OSD_INITIATOR should select CONFIG (HMAC) SHA1 somehow.
> -#        How is it done properly?
>  #
>
>  config SCSI_OSD_INITIATOR
>        tristate "OSD-Initiator library"
>        depends on SCSI
> +       select CRYPTO
> +       select CRYPTO_SHA1
> +       select CRYPTO_HMAC
>        help
>                Enable the OSD-Initiator library (libosd.ko).
> -               NOTE: You must also select CRYPTO_SHA1 + CRYPTO_HMAC and their
> -               dependencies
>
>  config SCSI_OSD_ULD
>        tristate "OSD Upper Level driver"
>
