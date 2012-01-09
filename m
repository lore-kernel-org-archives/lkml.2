Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932893Ab2AITMK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 14:12:10 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:51549 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371Ab2AITMJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 14:12:09 -0500
References: <1326121523-28634-2-git-send-email-jeff.dagenais@gmail.com> <1326127820-29682-1-git-send-email-jeff.dagenais@gmail.com>
In-Reply-To: <1326127820-29682-1-git-send-email-jeff.dagenais@gmail.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <AC457995-782F-4A2E-B97C-55B6C30A8373@gmail.com>
Content-Transfer-Encoding: 8BIT
Cc: linux-kernel@vger.kernel.org, michael.hennerich@analog.com,
        grant.likely@secretlab.ca
From: Jean-Francois Dagenais <jeff.dagenais@gmail.com>
Subject: Re: [PATCH 1/2] input: adp5588 - add support for gpio names
Date: Mon, 9 Jan 2012 14:16:55 -0500
To: =?iso-8859-1?Q?Jean-Fran=E7ois_Dagenais?= <jeff.dagenais@gmail.com>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, disregard. Bad "reply-to", wrong destination. Will resend.

On Jan 9, 2012, at 11:50, Jean-François Dagenais wrote:

> 
> Signed-off-by: Jean-François Dagenais <jeff.dagenais@gmail.com>
> Acked-by: Michael Hennerich <michael.hennerich@analog.com>
> ---
> drivers/input/keyboard/adp5588-keys.c |    1 +
> include/linux/i2c/adp5588.h           |    1 +
> 2 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/input/keyboard/adp5588-keys.c b/drivers/input/keyboard/adp5588-keys.c
> index e34eeb8..6412ced 100644
> --- a/drivers/input/keyboard/adp5588-keys.c
> +++ b/drivers/input/keyboard/adp5588-keys.c
> @@ -197,6 +197,7 @@ static int __devinit adp5588_gpio_add(struct adp5588_kpad *kpad)
> 	kpad->gc.base = gpio_data->gpio_start;
> 	kpad->gc.label = kpad->client->name;
> 	kpad->gc.owner = THIS_MODULE;
> +	kpad->gc.names = gpio_data->names;
> 
> 	mutex_init(&kpad->gpio_lock);
> 
> diff --git a/include/linux/i2c/adp5588.h b/include/linux/i2c/adp5588.h
> index cec17cf..d8341cb 100644
> --- a/include/linux/i2c/adp5588.h
> +++ b/include/linux/i2c/adp5588.h
> @@ -157,6 +157,7 @@ struct i2c_client; /* forward declaration */
> 
> struct adp5588_gpio_platform_data {
> 	int gpio_start;		/* GPIO Chip base # */
> +	const char *const *names;
> 	unsigned irq_base;	/* interrupt base # */
> 	unsigned pullup_dis_mask; /* Pull-Up Disable Mask */
> 	int	(*setup)(struct i2c_client *client,
> -- 
> 1.7.8.2
> 

