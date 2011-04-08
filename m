Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757364Ab1DHBuL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 21:50:11 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:34869 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757343Ab1DHBuK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 21:50:10 -0400
MIME-Version: 1.0
In-Reply-To: <1302197593-31815-1-git-send-email-iws@ovro.caltech.edu>
References: <1302197593-31815-1-git-send-email-iws@ovro.caltech.edu>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 7 Apr 2011 18:49:49 -0700
X-Google-Sender-Auth: HwFW040fHfDS_IQiJFkBOLcneEg
Message-ID: <BANLkTik4baLHkRTkuKNE9hzwnKp4wX--5g@mail.gmail.com>
Subject: Re: [PATCH] watchdog: mpc8xxx: fix build failure
To: "Ira W. Snyder" <iws@ovro.caltech.edu>
Cc: linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Ira.  Peter has already sent out a fix for tihs.

g.

On Thu, Apr 7, 2011 at 10:33 AM, Ira W. Snyder <iws@ovro.caltech.edu> wrote:
> Commit 1c48a5c93da63132b92c4bbcd18e690c51539df6 caused a build failure
> for the mpc8xxx watchdog driver. Fix it.
>
> Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: linux-watchdog@vger.kernel.org
> ---
>  drivers/watchdog/mpc8xxx_wdt.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/watchdog/mpc8xxx_wdt.c b/drivers/watchdog/mpc8xxx_wdt.c
> index 6709d72..528bceb 100644
> --- a/drivers/watchdog/mpc8xxx_wdt.c
> +++ b/drivers/watchdog/mpc8xxx_wdt.c
> @@ -195,7 +195,7 @@ static int __devinit mpc8xxx_wdt_probe(struct platform_device *ofdev)
>
>        if (!ofdev->dev.of_match)
>                return -EINVAL;
> -       wdt_type = match->data;
> +       wdt_type = ofdev->dev.of_match->data;
>
>        if (!freq || freq == -1)
>                return -EINVAL;
> --
> 1.7.3.4
>
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
