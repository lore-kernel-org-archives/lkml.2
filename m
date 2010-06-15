Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639Ab0FOFQl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 01:16:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4909 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188Ab0FOFQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 01:16:39 -0400
Message-ID: <4C170CA4.2020805@redhat.com>
Date: Tue, 15 Jun 2010 08:16:20 +0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Justin P. Mattock" <justinmattock@gmail.com>
CC: linux-kernel@vger.kernel.org, reiserfs-devel@vger.kernel.org,
       linux-bluetooth@vger.kernel.org, clemens@ladisch.de,
       debora@linux.vnet.ibm.com, dri-devel@lists.freedesktop.org,
       linux-i2c@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
       linux-media@vger.kernel.org
Subject: Re: [PATCH 8/8]tuners:tuner-simple Fix warning: variable 'tun' set
 but not used
References: <1276547208-26569-1-git-send-email-justinmattock@gmail.com> <1276547208-26569-9-git-send-email-justinmattock@gmail.com>
In-Reply-To: <1276547208-26569-9-git-send-email-justinmattock@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Em 14-06-2010 23:26, Justin P. Mattock escreveu:
> not sure if this is correct or not for 
> fixing this warning:
>   CC [M]  drivers/media/common/tuners/tuner-simple.o
> drivers/media/common/tuners/tuner-simple.c: In function 'simple_set_tv_freq':
> drivers/media/common/tuners/tuner-simple.c:548:20: warning: variable 'tun' set but not used
> 
>  Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> 
> ---
>  drivers/media/common/tuners/tuner-simple.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/common/tuners/tuner-simple.c b/drivers/media/common/tuners/tuner-simple.c
> index 8abbcc5..4465b99 100644
> --- a/drivers/media/common/tuners/tuner-simple.c
> +++ b/drivers/media/common/tuners/tuner-simple.c
> @@ -545,14 +545,12 @@ static int simple_set_tv_freq(struct dvb_frontend *fe,
>  	struct tuner_simple_priv *priv = fe->tuner_priv;
>  	u8 config, cb;
>  	u16 div;
> -	struct tunertype *tun;
>  	u8 buffer[4];
>  	int rc, IFPCoff, i;
>  	enum param_type desired_type;
>  	struct tuner_params *t_params;
>  
> -	tun = priv->tun;
> -
> +	
Why are you adding an extra blank line here? Except for that, the patch
looks sane.

>  	/* IFPCoff = Video Intermediate Frequency - Vif:
>  		940  =16*58.75  NTSC/J (Japan)
>  		732  =16*45.75  M/N STD

