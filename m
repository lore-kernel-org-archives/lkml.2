Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974Ab1HBJqS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 05:46:18 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:44611 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872Ab1HBJqK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 05:46:10 -0400
MIME-Version: 1.0
In-Reply-To: <CAGXE3d9ynyJX2eAr2bfwOc_PdDNEwVHDVsA_Jx1ReBht=eVuYw@mail.gmail.com>
References: <CAGXE3d9ynyJX2eAr2bfwOc_PdDNEwVHDVsA_Jx1ReBht=eVuYw@mail.gmail.com>
Date: Tue, 2 Aug 2011 11:46:09 +0200
Message-ID: <CAL1gcdNpRfznieegeSCLxeUP_0LRZmnzh91A8d3=+2VM1+S+8Q@mail.gmail.com>
Subject: Re: [PATCH] rt2x00: Fix compilation without CONFIG_RT2X00_LIB_CRYPTO
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-wireless@vger.kernel.org, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Ivo van Doorn <IvDoorn@gmail.com>,
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

OK. You beat me to it.

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
---
Gertjan
