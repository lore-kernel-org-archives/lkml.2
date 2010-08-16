Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390Ab0HPFWO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 01:22:14 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54846 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114Ab0HPFWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 01:22:13 -0400
X-User-Agent: K-9 Mail for Android
References: <20100809120509.be36a4fa.sfr@canb.auug.org.au> <20100816122059.c3ee7f6a.sfr@canb.auug.org.au>
In-Reply-To: <20100816122059.c3ee7f6a.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] spi: update for of_device to platform_device replacement
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sun, 15 Aug 2010 23:22:36 -0600
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus <torvalds@linux-foundation.org>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <df0c23b2-b602-4555-a363-795deb0cde28@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



"Stephen Rothwell" <sfr@canb.auug.org.au> wrote:

>
>Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

Acked-by: Grant Likely <grant.likely@secretlab.ca>


>---
> drivers/ata/sata_dwc_460ex.c |    4 ++--
> 1 files changed, 2 insertions(+), 2 deletions(-)
>
>Hi Grant,
>
>On Mon, 9 Aug 2010 12:05:09 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>
>> I also added this merge fix patch (as suggest by you):
>
>This patch now is needed in Linus' tree.  I will add it to my fixes tree
>for today.  Linus, can you take this, please?
>
>diff --git a/drivers/ata/sata_dwc_460ex.c b/drivers/ata/sata_dwc_460ex.c
>index ea24c1e..2673a3d 100644
>--- a/drivers/ata/sata_dwc_460ex.c
>+++ b/drivers/ata/sata_dwc_460ex.c
>@@ -1588,7 +1588,7 @@ static const struct ata_port_info sata_dwc_port_info[] = {
> 	},
> };
> 
>-static int sata_dwc_probe(struct of_device *ofdev,
>+static int sata_dwc_probe(struct platform_device *ofdev,
> 			const struct of_device_id *match)
> {
> 	struct sata_dwc_device *hsdev;
>@@ -1702,7 +1702,7 @@ error_out:
> 	return err;
> }
> 
>-static int sata_dwc_remove(struct of_device *ofdev)
>+static int sata_dwc_remove(struct platform_device *ofdev)
> {
> 	struct device *dev = &ofdev->dev;
> 	struct ata_host *host = dev_get_drvdata(dev);
>-- 
>1.7.1
>
>-- 
>Cheers,
>Stephen Rothwell                    sfr@canb.auug.org.au
>http://www.canb.auug.org.au/~sfr/

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
