Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568Ab0LIJKj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 04:10:39 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53015 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755522Ab0LIJKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 04:10:36 -0500
Subject: Re: [PATCH 29/29] drivers/regulator: Update WARN uses
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org
In-Reply-To: <b0588ea464d551f9dbd80c0fee68a780d6279b50.1291670106.git.joe@perches.com>
References: <cover.1291670104.git.joe@perches.com>
	 <b0588ea464d551f9dbd80c0fee68a780d6279b50.1291670106.git.joe@perches.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Dec 2010 09:10:31 +0000
Message-ID: <1291885831.3271.0.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-06 at 14:05 -0800, Joe Perches wrote:
> Align arguments.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/regulator/core.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
> index a1b1237..5d07e5d 100644
> --- a/drivers/regulator/core.c
> +++ b/drivers/regulator/core.c
> @@ -1379,8 +1379,7 @@ static int _regulator_disable(struct regulator_dev *rdev,
>  	*supply_rdev_ptr = NULL;
>  
>  	if (WARN(rdev->use_count <= 0,
> -			"unbalanced disables for %s\n",
> -			rdev_get_name(rdev)))
> +		 "unbalanced disables for %s\n", rdev_get_name(rdev)))
>  		return -EIO;
>  
>  	/* are we the last user and permitted to disable ? */

Applied.

Thanks

Liam
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

