Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326Ab2H1U50 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 16:57:26 -0400
Received: from co1ehsobe004.messaging.microsoft.com ([216.32.180.187]:56357
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752667Ab2H1U5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 16:57:24 -0400
X-Forefront-Antispam-Report: CIP:157.56.232.165;KIP:(null);UIP:(null);IPV:NLI;H:BLUPRD0810HT003.namprd08.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: PS-3(zzbb2dI98dI1432Izz1202hzz6d524h8275bhz2fh2a8h668h839hd25he5bhf0ah107ah10d2h1155h)
Message-ID: <503D30A6.3000800@ozmodevices.com>
Date: Tue, 28 Aug 2012 21:57:10 +0100
From: Rupesh Gujare <rgujare@ozmodevices.com>
Reply-To: <rgujare@ozmodevices.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Wei Yongjun <weiyj.lk@gmail.com>
CC: <ckelly@ozmodevices.com>, <gregkh@linuxfoundation.org>,
        <yongjun_wei@trendmicro.com.cn>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: ozwpan: remove pointless conditional before
 kfree_skb()
References: <CAPgLHd_u2CE7PAhS4Y9MtbY=ZFphZfUrYYiqD_gx6-kf1O0C-w@mail.gmail.com>
In-Reply-To: <CAPgLHd_u2CE7PAhS4Y9MtbY=ZFphZfUrYYiqD_gx6-kf1O0C-w@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [94.5.61.149]
X-OriginatorOrg: ozmodevices.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/08/2012 14:11, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Remove pointless conditional before kfree_skb().
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>   drivers/staging/ozwpan/ozpd.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/staging/ozwpan/ozpd.c b/drivers/staging/ozwpan/ozpd.c
> index 6c287ac..d515714 100644
> --- a/drivers/staging/ozwpan/ozpd.c
> +++ b/drivers/staging/ozwpan/ozpd.c
> @@ -752,8 +752,7 @@ int oz_isoc_stream_create(struct oz_pd *pd, u8 ep_num)
>    */
>   static void oz_isoc_stream_free(struct oz_isoc_stream *st)
>   {
> -	if (st->skb)
> -		kfree_skb(st->skb);
> +	kfree_skb(st->skb);
>   	kfree(st);
>   }
>   /*------------------------------------------------------------------------------
>
>



Acked-by: Rupesh Gujare <rgujare@ozmodevices.com>


