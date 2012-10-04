Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932461Ab2JDH6O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 03:58:14 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:9931 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932089Ab2JDH6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 03:58:13 -0400
Date: Thu, 4 Oct 2012 09:58:03 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Cc: linux-i2c@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: correct struct i2c_driver doc about detection
Message-ID: <20121004095803.26548bc7@endymion.delvare>
In-Reply-To: <1349295444-18645-1-git-send-email-vivien.didelot@savoirfairelinux.com>
References: <1349295444-18645-1-git-send-email-vivien.didelot@savoirfairelinux.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivien,

On Wed,  3 Oct 2012 16:17:24 -0400, Vivien Didelot wrote:
> s/address_data/address_list/ in addition to c3813d6.
> 
> Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
> ---
>  include/linux/i2c.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/i2c.h b/include/linux/i2c.h
> index 8e25a91..8d87329 100644
> --- a/include/linux/i2c.h
> +++ b/include/linux/i2c.h
> @@ -140,7 +140,7 @@ extern s32 i2c_smbus_write_i2c_block_data(const struct i2c_client *client,
>   * The driver.owner field should be set to the module owner of this driver.
>   * The driver.name field should be set to the name of this driver.
>   *
> - * For automatic device detection, both @detect and @address_data must
> + * For automatic device detection, both @detect and @address_list must
>   * be defined. @class should also be set, otherwise only devices forced
>   * with module parameters will be created. The detect function must
>   * fill at least the name field of the i2c_board_info structure it is

Good catch! Applied, thanks.

-- 
Jean Delvare
