Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab0F2SRF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 14:17:05 -0400
Received: from mail80c7.megamailservers.com ([69.49.98.180]:50624 "EHLO
	mail80c7.megamailservers.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754354Ab0F2SRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 14:17:03 -0400
X-Greylist: delayed 3999 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Jun 2010 14:17:03 EDT
X-Authenticated-User: paulkf.microgate.com
Message-ID: <4C2A36C6.3020101@microgate.com>
Date: Tue, 29 Jun 2010 12:09:10 -0600
From: Paul Fulghum <paulkf@microgate.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: Kulikov Vasiliy <segooon@gmail.com>
CC: trivial@kernel.org, Kernel Janitors <kernel-janitors@vger.kernel.org>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/16] trivial: use ARRAY_SIZE
References: <1277726089-24467-1-git-send-email-segooon@gmail.com>
In-Reply-To: <1277726089-24467-1-git-send-email-segooon@gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-CSC: 0
X-CHA: v=1.1 cv=mS14aLXsVDjuqhCeSQYt5ooTdy5XXOZhHx7Vus2DgyA= c=1 sm=1
		a=4Tz1Q6VkXRsA:10 a=ood2b7iyd8MA:10 a=8nJEP1OIZ-IA:10
		a=NZZe3g19dmt1xztwQ50WRw==:17 a=pGLkceISAAAA:8 a=ijWuk3ZyAAAA:8
		a=w9rof2AGrn1jCrruHmUA:9 a=bZfmuX8Xq4pLgkWYQbCWHy_TF1kA:4 a=wPNLvfGTeEIA:10
		a=MSl-tDqOz04A:10 a=fEugV1Gw4pQA:10 a=NZZe3g19dmt1xztwQ50WRw==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/28/2010 5:54 AM, Kulikov Vasiliy wrote:
> Change sizeof(x) / sizeof(*x) to ARRAY_SIZE(x).
> 
> Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
> ---
>  drivers/char/synclink_gt.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/char/synclink_gt.c b/drivers/char/synclink_gt.c
> index 4561ce2..334cf5c 100644
> --- a/drivers/char/synclink_gt.c
> +++ b/drivers/char/synclink_gt.c
> @@ -4845,7 +4845,7 @@ static int register_test(struct slgt_info *info)
>  {
>  	static unsigned short patterns[] =
>  		{0x0000, 0xffff, 0xaaaa, 0x5555, 0x6969, 0x9696};
> -	static unsigned int count = sizeof(patterns)/sizeof(patterns[0]);
> +	static unsigned int count = ARRAY_SIZE(patterns);
>  	unsigned int i;
>  	int rc = 0;
>  

Acked-by: Paul Fulghum <paulkf@microgate.com>

with the exception of the trailing CR :-)

-- 
Paul Fulghum
MicroGate Systems, Ltd.
