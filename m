Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758193Ab1GDQFr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 12:05:47 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60026 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757927Ab1GDQFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 12:05:46 -0400
Subject: Re: [PATCH] regulator: max8952 - fix wrong gpio valid check
From: Liam Girdwood <lrg@kernel.org>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        jhbird.choi@samsung.com, myungjoo.ham@gmail.com
In-Reply-To: <1308128052-27739-1-git-send-email-myungjoo.ham@samsung.com>
References: <1308128052-27739-1-git-send-email-myungjoo.ham@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Jul 2011 17:05:40 +0100
Message-ID: <1309795541.3272.6.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-15 at 17:54 +0900, MyungJoo Ham wrote:
> From: Jonghwan Choi <jhbird.choi@samsung.com>
> 
> Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
> Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> ---
>  drivers/regulator/max8952.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/regulator/max8952.c b/drivers/regulator/max8952.c
> index daff7fd..486ed81 100644
> --- a/drivers/regulator/max8952.c
> +++ b/drivers/regulator/max8952.c
> @@ -139,7 +139,7 @@ static int max8952_set_voltage(struct regulator_dev *rdev,
>  	s8 vid = -1, i;
>  
>  	if (!gpio_is_valid(max8952->pdata->gpio_vid0) ||
> -			!gpio_is_valid(max8952->pdata->gpio_vid0)) {
> +			!gpio_is_valid(max8952->pdata->gpio_vid1)) {
>  		/* DVS not supported */
>  		return -EPERM;
>  	}

Applied.

Thanks

Liam

