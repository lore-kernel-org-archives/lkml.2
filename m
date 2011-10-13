Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab1JMTqs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 15:46:48 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:52953 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053Ab1JMTqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 15:46:47 -0400
Date: Thu, 13 Oct 2011 13:46:44 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Hartmut Knaack <knaack.h@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Patch 1/2] gpio-pca953x: fix gpio_base and add verbosity
Message-ID: <20111013194644.GF18574@ponder.secretlab.ca>
References: <4E937035.8020806@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E937035.8020806@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 11, 2011 at 12:22:45AM +0200, Hartmut Knaack wrote:
> gpio_base was set to 0 if no system platform data or open firmware
> platform data was provided. This led to conflicts, if any other gpiochip
> with a gpiobase of 0 was instantiated already. Setting it to -1 will
> automatically use the first one available.
> 
> Signed-off-by: Hartmut Knaack <knaack.h@gmx.de>
> -------------------------------------------------------------

Corrupt patch (linewrap and whitespace damage).  Please check your mailer.

> diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
> index c43b8ff..ae479fd 100644
> --- a/drivers/gpio/gpio-pca953x.c
> +++ b/drivers/gpio/gpio-pca953x.c
> @@ -577,6 +577,7 @@ pca953x_get_alt_pdata(struct i2c_client *client, int
> *gpio_base, int *invert)
>  void
>  pca953x_get_alt_pdata(struct i2c_client *client, int *gpio_base, int
> *invert)
>  {
> +  *gpio_base = -1;
>  }
>  #endif
>  
> 
