Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663Ab2IGQBO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 12:01:14 -0400
Received: from mail.kapsi.fi ([217.30.184.167]:55132 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781Ab2IGQBN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 12:01:13 -0400
Message-ID: <504A1A32.1010005@iki.fi>
Date: Fri, 07 Sep 2012 19:00:50 +0300
From: Antti Palosaari <crope@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Peter Senna Tschudin <peter.senna@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
        kernel-janitors@vger.kernel.org, Julia.Lawall@lip6.fr,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 9/10] drivers/media/dvb-frontends/tda10071.c: removes
 unnecessary semicolon
References: <1347031488-26598-5-git-send-email-peter.senna@gmail.com>
In-Reply-To: <1347031488-26598-5-git-send-email-peter.senna@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 82.128.184.7
X-SA-Exim-Mail-From: crope@iki.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/2012 06:24 PM, Peter Senna Tschudin wrote:
> From: Peter Senna Tschudin <peter.senna@gmail.com>
>
> removes unnecessary semicolon
>
> Found by Coccinelle: http://coccinelle.lip6.fr/
>
> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
>
> ---
>   drivers/media/dvb-frontends/tda10071.c |    4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff -u -p a/drivers/media/dvb-frontends/tda10071.c b/drivers/media/dvb-frontends/tda10071.c
> --- a/drivers/media/dvb-frontends/tda10071.c
> +++ b/drivers/media/dvb-frontends/tda10071.c
> @@ -257,7 +257,7 @@ static int tda10071_set_voltage(struct d
>   				__func__);
>   		ret = -EINVAL;
>   		goto error;
> -	};
> +	}
>
>   	cmd.args[0] = CMD_LNB_SET_DC_LEVEL;
>   	cmd.args[1] = 0;
> @@ -369,7 +369,7 @@ static int tda10071_diseqc_recv_slave_re
>   	if (ret)
>   		goto error;
>
> -	reply->msg_len = tmp & 0x1f; /* [4:0] */;
> +	reply->msg_len = tmp & 0x1f; /* [4:0] */
>   	if (reply->msg_len > sizeof(reply->msg))
>   		reply->msg_len = sizeof(reply->msg); /* truncate API max */
>
>

Acked-by: Antti Palosaari <crope@iki.fi>

Antti
-- 
http://palosaari.fi/
