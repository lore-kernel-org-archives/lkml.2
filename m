Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924Ab2AKRf4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 12:35:56 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55970 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757847Ab2AKRfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 12:35:54 -0500
Date: Wed, 11 Jan 2012 09:35:40 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Michael Thalmeier <michael.thalmeier@hale.at>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        michael@thalmeier.at
Subject: Re: [PATCH v2] input/mc13783-ts: add pdata to set conversion delay
Message-ID: <20120111173540.GC21047@core.coreip.homeip.net>
References: <1326278963-22510-1-git-send-email-michael.thalmeier@hale.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326278963-22510-1-git-send-email-michael.thalmeier@hale.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 11:49:23AM +0100, Michael Thalmeier wrote:
>  
> +struct mc13xxx_ts_platform_data {
> +	/* Delay between Touchscreen polarization and ADC Conversion.
> +	 * Given in clock ticks of a 32 kHz clock which gives a granularity of
> +	 * about 30.5ms */
> +	char ato;
> +
> +#define MC13783_TS_ATO_FIRST 0
> +#define MC13783_TS_ATO_EACH  1
> +	/* Use the ATO delay only for the first conversion or for each one */
> +	char atox;
> +};


'char' for these 2 looks wrong, 2 u8, u8 and bool or int and bool would
be better.

Otherwise am OK with input bits.

Acked-by: Dmitry Torokhov <dtor@mail.ru>

-- 
Dmitry
