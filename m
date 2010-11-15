Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758485Ab0KOVHX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 16:07:23 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:21103 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758459Ab0KOVHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 16:07:22 -0500
Date: Mon, 15 Nov 2010 22:06:55 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <trivial@kernel.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/11] drivers/i2c/busses/i2c-nforce2.c: Remove
 unnecessary casts of pci_get_drvdata
Message-ID: <20101115220655.3c2600f6@endymion.delvare>
In-Reply-To: <8202cea15da761f594353ae6906e1414b1f1f152.1289851770.git.joe@perches.com>
References: <cover.1289851770.git.joe@perches.com>
	<8202cea15da761f594353ae6906e1414b1f1f152.1289851770.git.joe@perches.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Nov 2010 12:13:52 -0800, Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/i2c/busses/i2c-nforce2.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-nforce2.c b/drivers/i2c/busses/i2c-nforce2.c
> index a605a50..ff1e127 100644
> --- a/drivers/i2c/busses/i2c-nforce2.c
> +++ b/drivers/i2c/busses/i2c-nforce2.c
> @@ -432,7 +432,7 @@ static int __devinit nforce2_probe(struct pci_dev *dev, const struct pci_device_
>  
>  static void __devexit nforce2_remove(struct pci_dev *dev)
>  {
> -	struct nforce2_smbus *smbuses = (void*) pci_get_drvdata(dev);
> +	struct nforce2_smbus *smbuses = pci_get_drvdata(dev);
>  
>  	nforce2_set_reference(NULL);
>  	if (smbuses[0].base) {

Applied, thanks.

-- 
Jean Delvare
