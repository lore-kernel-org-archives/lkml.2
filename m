Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759174Ab1EMMeu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 08:34:50 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:50959 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759129Ab1EMMes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 08:34:48 -0400
Subject: Re: [PATCH] regulator: max8997: remove useless code
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jonghwan Choi <jhbird.choi@samsung.com>, myungjoo.ham@gmail.com
In-Reply-To: <1305167868-9080-1-git-send-email-myungjoo.ham@samsung.com>
References: <1305167868-9080-1-git-send-email-myungjoo.ham@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 May 2011 13:34:43 +0100
Message-ID: <1305290083.3202.5.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-12 at 11:37 +0900, MyungJoo Ham wrote:
> From: Jonghwan Choi <jhbird.choi@samsung.com>
> 
> fix unreachable code.
> 
> Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> ---
>  drivers/regulator/max8997.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/regulator/max8997.c b/drivers/regulator/max8997.c
> index 77e0cfb..b1c1444 100644
> --- a/drivers/regulator/max8997.c
> +++ b/drivers/regulator/max8997.c
> @@ -267,7 +267,6 @@ static int max8997_get_enable_register(struct regulator_dev *rdev,
>  	default:
>  		/* Not controllable or not exists */
>  		return -EINVAL;
> -		break;
>  	}
>  
>  	return 0;


Applied.

Liam

