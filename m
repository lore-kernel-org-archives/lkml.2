Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759554Ab2INMZ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 08:25:58 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:33859 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755794Ab2INMZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 08:25:57 -0400
X-Authenticated: #9962044
X-Provags-ID: V01U2FsdGVkX18J+WFU2aMJQYX32ATrb4mhv9+cELxIdJbHpxw1v1
	p4cYpPQZO9exzY
From: Marc Dietrich <marvin24@gmx.de>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Julian Andres Klode <jak@jak-linux.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ac100@lists.launchpad.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: nvec: Update for recent MFD core changes
Date: Fri, 14 Sep 2012 14:25:53 +0200
Message-ID: <3024745.a3O1qxCH7D@fb07-iapwap2>
User-Agent: KMail/4.9.1 (Linux/3.6.0-rc4-3-desktop; KDE/4.9.1; x86_64; ; )
In-Reply-To: <1347623064-28348-1-git-send-email-thierry.reding@avionic-design.de>
References: <1347623064-28348-1-git-send-email-thierry.reding@avionic-design.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="ISO-8859-1"
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thierry,

Am Freitag, 14. September 2012, 13:44:24 schrieb Thierry Reding:
> mfd_add_devices() was recently changed to receive the IRQ domain through
> an additional parameter but this driver wasn't updated accordingly.
> 
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> ---

this was already kindly fixed by Stephen Warren a few days ago and will be 
included in linux-next.

Marc

>  drivers/staging/nvec/nvec.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/nvec/nvec.c b/drivers/staging/nvec/nvec.c
> index b0972d0..24d8eeb 100644
> --- a/drivers/staging/nvec/nvec.c
> +++ b/drivers/staging/nvec/nvec.c
> @@ -837,7 +837,7 @@ static int __devinit tegra_nvec_probe(struct
> platform_device *pdev) }
> 
>  	ret = mfd_add_devices(nvec->dev, -1, nvec_devices,
> -			      ARRAY_SIZE(nvec_devices), base, 0);
> +			      ARRAY_SIZE(nvec_devices), base, 0, NULL);
>  	if (ret)
>  		dev_err(nvec->dev, "error adding subdevices\n");
