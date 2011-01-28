Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506Ab1A1Tye (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 14:54:34 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:38041 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753287Ab1A1Tyb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 14:54:31 -0500
Subject: Re: [PATCH]drivers:wireless:acx.h change initate to initiate
From: Luciano Coelho <coelho@ti.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
CC: "trivial@kernel.org" <trivial@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1296244204-3890-1-git-send-email-justinmattock@gmail.com>
References: <1296244204-3890-1-git-send-email-justinmattock@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 Jan 2011 21:54:04 +0200
Message-ID: <1296244444.3069.399.camel@pimenta>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-28 at 20:50 +0100, Justin P. Mattock wrote:
> Not sure if this is a typo or not. if it is then feel free to take this.
> 
> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> 
> ---
>  drivers/net/wireless/wl12xx/acx.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/wl12xx/acx.h b/drivers/net/wireless/wl12xx/acx.h
> index 7bd8e4d..c56088b 100644
> --- a/drivers/net/wireless/wl12xx/acx.h
> +++ b/drivers/net/wireless/wl12xx/acx.h
> @@ -987,7 +987,7 @@ struct wl1271_acx_ht_capabilities {
>  	 *         Note, driver will still leave space for HT control in packets
>  	 *         regardless of the value of this field. FW will be responsible
>  	 *         to drop the HT field from any frame when this Bit set to 0.
> -	 * bit 5 - Allow RD initiation in TXOP. FW is allowed to initate RD.
> +	 * bit 5 - Allow RD initiation in TXOP. FW is allowed to initiate RD.
>  	 *         Exact policy setting for this feature is TBD.
>  	 *         Note, this bit can only be set to 1 if bit 3 is set to 1.
>  	 */

Yep, it's a typo.  Thanks for fixing it.

Acked-by: Luciano Coelho <coelho@ti.com>

-- 
Cheers,
Luca.

