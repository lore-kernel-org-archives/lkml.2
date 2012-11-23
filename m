Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932879Ab2KWHB4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 02:01:56 -0500
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:4777 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932352Ab2KWHBy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 02:01:54 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dIc89bh1432Izz1de0h1202h1d1ah1d2ahzz17326ah8275dhz2dh2a8h668h839hd25hd2bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1155h)
Date: Fri, 23 Nov 2012 15:01:45 +0800
From: Peter Chen <peter.chen@freescale.com>
To: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
CC: Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] USB: chipidea: promote error code from ci_role_start()
 start instead of returning -ENODEV
Message-ID: <20121123070144.GF22420@nchen-desktop>
References: <1353575491-23976-1-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <1353575491-23976-1-git-send-email-LW@KARO-electronics.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 22, 2012 at 10:11:31AM +0100, Lothar Waﬂmann wrote:
> 
> Signed-off-by: Lothar Waﬂmann <LW@KARO-electronics.de>
> ---
>  drivers/usb/chipidea/core.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/usb/chipidea/core.c b/drivers/usb/chipidea/core.c
> index b726c49..bd6e7a4 100644
> --- a/drivers/usb/chipidea/core.c
> +++ b/drivers/usb/chipidea/core.c
> @@ -479,7 +479,6 @@ static int __devinit ci_hdrc_probe(struct platform_device *pdev)
>  	ret = ci_role_start(ci, ci->role);
>  	if (ret) {
>  		dev_err(dev, "can't start %s role\n", ci_role(ci)->name);
> -		ret = -ENODEV;
>  		goto rm_wq;
>  	}
Any reasons?
>  
> -- 
> 1.7.2.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 

Best Regards,
Peter Chen

