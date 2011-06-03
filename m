Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439Ab1FCC0P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 22:26:15 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62841 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493Ab1FCC0O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 22:26:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=NrlIIcFv4HIwN0v/6rP3Dt97FVfIKjV2BRAhUeBqT7mATFslGjvoafGqHm9KACXAqg
         vzlIErj58SbQHvBSNaUmFTlwc3nsJg3whzC2myu2GWMPgjvbe8iV9/nBRmqxlRvXpCsv
         XDe1EG9w100KojXGYaBhvJtAfJREYsyAxtZ+Y=
MIME-Version: 1.0
In-Reply-To: <1307065913.10001.2.camel@phoenix>
References: <1307065913.10001.2.camel@phoenix>
From: Wan ZongShun <mcuos.com@gmail.com>
Date: Fri, 3 Jun 2011 10:25:52 +0800
Message-ID: <BANLkTikeK=bPMSrWEmjk6x=KwREJyajzvg@mail.gmail.com>
Subject: Re: [PATCH 1/2] mtd: nuc900_nand: add missing nand_release in nuc900_nand_remove
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        linux-mtd@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/6/3 Axel Lin <axel.lin@gmail.com>:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Wan ZongShun <mcuos.com@gmail.com>

Thanks!

> ---
>  drivers/mtd/nand/nuc900_nand.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/mtd/nand/nuc900_nand.c b/drivers/mtd/nand/nuc900_nand.c
> index 9c30a0b..fa8faed 100644
> --- a/drivers/mtd/nand/nuc900_nand.c
> +++ b/drivers/mtd/nand/nuc900_nand.c
> @@ -339,6 +339,7 @@ static int __devexit nuc900_nand_remove(struct platform_device *pdev)
>        struct nuc900_nand *nuc900_nand = platform_get_drvdata(pdev);
>        struct resource *res;
>
> +       nand_release(&nuc900_nand->mtd);
>        iounmap(nuc900_nand->reg);
>
>        res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> --
> 1.7.4.1
>
>
>
>



-- 
Wan ZongShun.
www.mcuos.com
