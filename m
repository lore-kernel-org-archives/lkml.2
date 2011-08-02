Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994Ab1HBJsq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 05:48:46 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:44311 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208Ab1HBJsm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 05:48:42 -0400
MIME-Version: 1.0
In-Reply-To: <CAGXE3d9ynyJX2eAr2bfwOc_PdDNEwVHDVsA_Jx1ReBht=eVuYw@mail.gmail.com>
References: <CAGXE3d9ynyJX2eAr2bfwOc_PdDNEwVHDVsA_Jx1ReBht=eVuYw@mail.gmail.com>
Date: Tue, 2 Aug 2011 11:48:41 +0200
Message-ID: <CAOZOX0UhkkCj-n=WG7c7qxqfG4=Y1QScs0FQXS0ZNwBBS=N98A@mail.gmail.com>
Subject: Re: [PATCH] rt2x00: Fix compilation without CONFIG_RT2X00_LIB_CRYPTO
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-wireless@vger.kernel.org, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 2, 2011 at 11:43 AM, Helmut Schaa
<helmut.schaa@googlemail.com> wrote:
> This was introduced by commit
> 77b5621bac4a56b83b9081f48d4e7d1accdde400 (rt2x00: Don't use queue entry
> as parameter when creating TX descriptor.)
>
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
> Sending directly to John as I assume this should go through the wireless tree?
>
>  drivers/net/wireless/rt2x00/rt2x00lib.h |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h
> b/drivers/net/wireless/rt2x00/rt2x00lib.h
> index 15cdc7e..4cdf247 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00lib.h
> +++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
> @@ -355,7 +355,8 @@ static inline enum cipher
> rt2x00crypto_key_to_cipher(struct ieee80211_key_conf *
>        return CIPHER_NONE;
>  }
>
> -static inline void rt2x00crypto_create_tx_descriptor(struct queue_entry *entry,
> +static inline void rt2x00crypto_create_tx_descriptor(struct
> rt2x00_dev *rt2x00dev,
> +                                                    struct sk_buff *skb,
>                                                     struct txentry_desc *txdesc)
>  {
>  }
> --
> 1.7.3.4
>
