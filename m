Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230Ab1AYWPW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 17:15:22 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:16593 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827Ab1AYWPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 17:15:21 -0500
Date: Tue, 25 Jan 2011 23:15:13 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Peter Huewe <peterhuewe@gmx.de>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] video/via: drop deprecated (and unused) i2c_adapter.id
Message-ID: <20110125231513.19e133dd@endymion.delvare>
In-Reply-To: <1295991264-8640-1-git-send-email-peterhuewe@gmx.de>
References: <1295991264-8640-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Jan 2011 22:34:24 +0100, Peter Huewe wrote:
> This patch removes an assignment to the deprecated i2c_adapter.id
> field. Since the field isn't used anywhere else in the driver it is
> save to remove it.
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>

Acked-by: Jean Delvare <khali@linux-fr.org>

> ---
>  drivers/video/via/via_i2c.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/video/via/via_i2c.c b/drivers/video/via/via_i2c.c
> index 3844b55..a172a31 100644
> --- a/drivers/video/via/via_i2c.c
> +++ b/drivers/video/via/via_i2c.c
> @@ -209,7 +209,6 @@ static int create_i2c_bus(struct i2c_adapter *adapter,
>  	sprintf(adapter->name, "viafb i2c io_port idx 0x%02x",
>  		adap_cfg->ioport_index);
>  	adapter->owner = THIS_MODULE;
> -	adapter->id = 0x01FFFF;
>  	adapter->class = I2C_CLASS_DDC;
>  	adapter->algo_data = algo;
>  	if (pdev)


-- 
Jean Delvare
