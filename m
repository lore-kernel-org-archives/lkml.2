Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893Ab2GYHaJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 03:30:09 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:51359 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751858Ab2GYHaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 03:30:07 -0400
Message-ID: <1343201406.30161.10.camel@joe2Laptop>
Subject: Re: [PATCH] fixed coding style issues
From: Joe Perches <joe@perches.com>
To: Baodong Chen <chenbdchenbd@gmail.com>
Cc: dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 25 Jul 2012 00:30:06 -0700
In-Reply-To: <1343200277-14385-1-git-send-email-chenbdchenbd@gmail.com>
References: <1343200277-14385-1-git-send-email-chenbdchenbd@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-25 at 15:11 +0800, Baodong Chen wrote:
> Fexed coding style issues from scripts/checkpatch.pl in drivers/input

Not all checkpatch messages need to be "fexed". :)

Please use some taste and judgment before submitting
patches based solely on checkpatch output.

> diff --git a/drivers/input/apm-power.c b/drivers/input/apm-power.c
[]
> @@ -33,7 +33,7 @@ static void system_power_event(unsigned int keycode)
>  }
>  
>  static void apmpower_event(struct input_handle *handle, unsigned int type,
> -		        unsigned int code, int value)
> +			unsigned int code, int value)

Perhaps prefer alignment to immediately after open parenthesis.

> diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
[]
> @@ -547,16 +547,44 @@ static int handle_eviocgbit(struct input_dev *dev,
>  
>  	switch (type) {
>  
> -	case      0: bits = dev->evbit;  len = EV_MAX;  break;
[]
> +	case      0:
> +		bits = dev->evbit;
> +		len = EV_MAX;
> +		break;

not all that better really.

> @@ -567,8 +595,8 @@ static int handle_eviocgbit(struct input_dev *dev,
>  	if (type == EV_KEY && size == OLD_KEY_MAX) {
>  		len = OLD_KEY_MAX;
>  		if (printk_timed_ratelimit(&keymax_warn_time, 10 * 1000))
> -			pr_warning("(EVIOCGBIT): Suspicious buffer size %u, "
> -				   "limiting output to %zu bytes. See "
> +			pr_warn("(EVIOCGBIT): Suspicious buffer size %u, " \
> +				   "limiting output to %zu bytes. See "	\

The line continuations are also not necessary and I think are
really ugly.  Just coalesce the format.

>  				   "http://userweb.kernel.org/~dtor/eviocgbit-bug.html\n",

dead link I think.

> diff --git a/drivers/input/ff-core.c b/drivers/input/ff-core.c
[]
> @@ -138,8 +138,8 @@ int input_ff_upload(struct input_dev *dev, struct ff_effect *effect,
>  
>  	if (effect->id == -1) {
>  		for (id = 0; id < ff->max_effects; id++)
> -		     if (!ff->effect_owners[id])
> -			break;
> +			if (!ff->effect_owners[id])
> +				break;

Better surrounded by braces too.

cheers, Joe


