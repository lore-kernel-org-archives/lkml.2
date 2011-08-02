Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520Ab1HBRKw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 13:10:52 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:41416 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754154Ab1HBRKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 13:10:48 -0400
Date: Tue, 2 Aug 2011 10:10:45 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-wireless@vger.kernel.org, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Ivo van Doorn <IvDoorn@gmail.com>
Subject: Re: [PATCH] rt2x00: Fix compilation without
 CONFIG_RT2X00_LIB_CRYPTO
Message-Id: <20110802101045.11001f21.rdunlap@xenotime.net>
In-Reply-To: <CAGXE3d9ynyJX2eAr2bfwOc_PdDNEwVHDVsA_Jx1ReBht=eVuYw@mail.gmail.com>
References: <CAGXE3d9ynyJX2eAr2bfwOc_PdDNEwVHDVsA_Jx1ReBht=eVuYw@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Aug 2011 11:43:14 +0200 Helmut Schaa wrote:

> This was introduced by commit
> 77b5621bac4a56b83b9081f48d4e7d1accdde400 (rt2x00: Don't use queue entry
> as parameter when creating TX descriptor.)
> 
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>

Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.

> ---
> Sending directly to John as I assume this should go through the wireless tree?
> 
>  drivers/net/wireless/rt2x00/rt2x00lib.h |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h
> b/drivers/net/wireless/rt2x00/rt2x00lib.h
> index 15cdc7e..4cdf247 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00lib.h
> +++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
> @@ -355,7 +355,8 @@ static inline enum cipher
> rt2x00crypto_key_to_cipher(struct ieee80211_key_conf *
>  	return CIPHER_NONE;
>  }
> 
> -static inline void rt2x00crypto_create_tx_descriptor(struct queue_entry *entry,
> +static inline void rt2x00crypto_create_tx_descriptor(struct
> rt2x00_dev *rt2x00dev,
> +						     struct sk_buff *skb,
>  						     struct txentry_desc *txdesc)
>  {
>  }
> -- 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
