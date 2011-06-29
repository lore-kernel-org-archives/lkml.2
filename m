Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471Ab1F2S26 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 14:28:58 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:25284 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756837Ab1F2S25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 14:28:57 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6392"; a="100674581"
Message-ID: <4E0B6EE8.9070202@codeaurora.org>
Date: Wed, 29 Jun 2011 11:28:56 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Anirudh Ghayal <aghayal@codeaurora.org>
CC: Lars-Peter Clausen <lars@metafoo.de>, Richard Purdie <rpurdie@rpsys.net>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Trilok Soni <tsoni@codeaurora.org>
Subject: Re: [PATCH V1] led: pm8xxx: Add pm8xxx leds driver
References: <1308739783-4643-1-git-send-email-aghayal@codeaurora.org>
In-Reply-To: <1308739783-4643-1-git-send-email-aghayal@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2011 03:49 AM, Anirudh Ghayal wrote:
> +
> +/**
> + * struct pm8xxx_led_data - internal led data structure
> + * @led_classdev - led class device
> + * @id - led index
> + * @led_brightness - led brightness levels
> + * @work - workqueue for led
> + * @lock - to protect the transactions
> + * @reg - cached value of led register
> + */

This isn't kerneldoc notation.

> +fail_id_check:
> +	if (i > 0) {
> +		for (i = i - 1; i >= 0; i--) {
> +			int index = pdata->leds[i].flags;
> +			mutex_destroy(&led[index].lock);
> +			led_classdev_unregister(&led[index].cdev);
> +		}
> +	}

if (i > 0) is redundant here.

> +/**
> + * enum pm8xxx_leds - PMIC8XXX supported led ids
> + * @PM8XXX_ID_LED_KB_LIGHT - keyboard backlight led
> + * @PM8XXX_ID_LED_0 - First low current led
> + * @PM8XXX_ID_LED_1 - Second low current led
> + * @PM8XXX_ID_LED_2 - Third low current led
> + * @PM8XXX_ID_FLASH_LED_0 - First flash led
> + * @PM8XXX_ID_FLASH_LED_0 - Second flash led
> + */
> +

This isn't kerneldoc notation.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

