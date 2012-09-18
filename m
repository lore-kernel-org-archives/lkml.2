Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751691Ab2IREHQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 00:07:16 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:51792 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840Ab2IREHO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 00:07:14 -0400
MIME-Version: 1.0
X-Originating-IP: [46.116.118.250]
In-Reply-To: <1347559440-6668-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1347559440-6668-1-git-send-email-sjur.brandeland@stericsson.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 18 Sep 2012 07:06:53 +0300
Message-ID: <CAK=Wgbb1--TtkK=XsDG-LOa_Dpr=BGSOzZezrpiD1k75SFUPog@mail.gmail.com>
Subject: Re: [PATCH] remoteproc: Add dependency to HAS_DMA
To: sjur.brandeland@stericsson.com
Cc: =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjurbren@gmail.com>,
        linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sjur,

On Thu, Sep 13, 2012 at 9:03 PM,  <sjur.brandeland@stericsson.com> wrote:
> From: Sjur Brændeland <sjur.brandeland@stericsson.com>
>
> Remoteproc relies on HAS_DMA, add this dependency in Kconfig.
>
> Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>

Applied to remoteproc-next, thanks.

Btw:

> ---
> cc: linux-kernel@vger.kernel.org
> cc: Rusty Russell <rusty@rustcorp.com.au>

These should be above the dashes if you want them included in the patch.

>
>  drivers/remoteproc/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/remoteproc/Kconfig b/drivers/remoteproc/Kconfig
> index f8d818a..e7d440c 100644
> --- a/drivers/remoteproc/Kconfig
> +++ b/drivers/remoteproc/Kconfig
> @@ -4,6 +4,7 @@ menu "Remoteproc drivers (EXPERIMENTAL)"
>  config REMOTEPROC
>         tristate
>         depends on EXPERIMENTAL
> +       depends on HAS_DMA

I've added this to OMAP_REMOTEPROC too, because recursive dependencies
don't work (REMOTEPROC could still be selected without HAS_DMA).

Thanks,
Ohad.
