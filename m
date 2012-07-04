Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847Ab2GDU7H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 16:59:07 -0400
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:48920 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752938Ab2GDU7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 16:59:02 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 4 Jul 2012 13:58:49 -0700
Subject: RE: [PATCH] wireless: fix leak found by coverity
Thread-Topic: [PATCH] wireless: fix leak found by coverity
Thread-Index: Ac1Z8ivUkP4Hfy/5SDOWbEKItQ15FwANMiAg
Message-ID: <477F20668A386D41ADCC57781B1F7043083AA5506F@SC-VEXCH1.marvell.com>
References: <20120704153327.4012.76171.stgit@bluebook>
In-Reply-To: <20120704153327.4012.76171.stgit@bluebook>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q64KxXm5025073

Hi Alan,

> Subject: [PATCH] wireless: fix leak found by coverity

I've sent a similar patch to linux-wireless list.

[PATCH 3.5] mwifiex: fix Coverity SCAN CID 709078: Resource leak (RESOURCE_LEAK)

http://marc.info/?l=linux-wireless&m=134135643727424&w=2

Thanks,
Bing

> 
> From: Alan Cox <alan@linux.intel.com>
> 
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> ---
> 
>  drivers/net/wireless/mwifiex/cfg80211.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
> index 97de652..497a05a 100644
> --- a/drivers/net/wireless/mwifiex/cfg80211.c
> +++ b/drivers/net/wireless/mwifiex/cfg80211.c
> @@ -1003,6 +1003,7 @@ static int mwifiex_cfg80211_start_ap(struct wiphy *wiphy,
>  	case NL80211_HIDDEN_SSID_ZERO_CONTENTS:
>  		/* firmware doesn't support this type of hidden SSID */
>  	default:
> +		kfree(bss_cfg);
>  		return -EINVAL;
>  	}
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
