Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098Ab1CLPbl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 10:31:41 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:35867 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753918Ab1CLPbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 10:31:39 -0500
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX19yZTouTKJy5aCNQ5yJPDzI+em+bgyBNhWgSPr03j
	9z73WG+g67/xgo
Message-ID: <4D7B91D7.807@gmx.de>
Date: Sat, 12 Mar 2011 16:31:35 +0100
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100328)
MIME-Version: 1.0
To: Peter Huewe <peterhuewe@gmx.de>
CC: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH] video/via: drop deprecated (and unused) i2c_adapter.id
References: <1295991264-8640-1-git-send-email-peterhuewe@gmx.de>
In-Reply-To: <1295991264-8640-1-git-send-email-peterhuewe@gmx.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Huewe schrieb:
> This patch removes an assignment to the deprecated i2c_adapter.id
> field. Since the field isn't used anywhere else in the driver it is
> save to remove it.
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>

Applied. Thanks,


Florian Tobias Schandinat

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

