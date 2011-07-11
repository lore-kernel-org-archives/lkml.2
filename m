Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757651Ab1GKVYI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 17:24:08 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:55503 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870Ab1GKVYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 17:24:07 -0400
MIME-Version: 1.0
In-Reply-To: <e554bed5c753a3fe85d3be34983a15e6110a6e35.1310289795.git.joe@perches.com>
References: <cover.1310289795.git.joe@perches.com>
	<e554bed5c753a3fe85d3be34983a15e6110a6e35.1310289795.git.joe@perches.com>
Date: Tue, 12 Jul 2011 00:24:05 +0300
Message-ID: <CAFtRNNwx0=8VnqRuHaOetCk2em78pOZ_rr74SpCNCxKuh1surw@mail.gmail.com>
Subject: Re: [PATCH 3/5] ath5k: Add missing breaks in switch/case
From: Nick Kossifidis <mickflemm@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Jiri Slaby <jirislaby@gmail.com>,
        "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        Bob Copeland <me@bobcopeland.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p6BLOG8r012475

2011/7/10 Joe Perches <joe@perches.com>:
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
> Â drivers/net/wireless/ath/ath5k/desc.c | Â  Â 3 +++
> Â 1 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath5k/desc.c b/drivers/net/wireless/ath/ath5k/desc.c
> index 62172d5..f82383b 100644
> --- a/drivers/net/wireless/ath/ath5k/desc.c
> +++ b/drivers/net/wireless/ath/ath5k/desc.c
> @@ -107,10 +107,13 @@ ath5k_hw_setup_2word_tx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc,
> Â  Â  Â  Â  Â  Â  Â  Â case AR5K_PKT_TYPE_BEACON:
> Â  Â  Â  Â  Â  Â  Â  Â case AR5K_PKT_TYPE_PROBE_RESP:
> Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â frame_type = AR5K_AR5210_TX_DESC_FRAME_TYPE_NO_DELAY;
> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  break;
> Â  Â  Â  Â  Â  Â  Â  Â case AR5K_PKT_TYPE_PIFS:
> Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â frame_type = AR5K_AR5210_TX_DESC_FRAME_TYPE_PIFS;
> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  break;
> Â  Â  Â  Â  Â  Â  Â  Â default:
> Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â frame_type = type;
> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  break;
> Â  Â  Â  Â  Â  Â  Â  Â }
>
> Â  Â  Â  Â  Â  Â  Â  Â tx_ctl->tx_control_0 |=

Acked-by: Nick Kossifidis <mickflemm@gmail.com>



-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
