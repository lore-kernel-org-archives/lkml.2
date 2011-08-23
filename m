Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368Ab1HWNwm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 09:52:42 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47886 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316Ab1HWNwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 09:52:36 -0400
Date: Tue, 23 Aug 2011 17:52:31 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Vasily Khoruzhick <anarsoul@gmail.com>
Subject: Re: [PATCH] power_supply: s3c_adc_battery: Needs module.h
Message-ID: <20110823135231.GA5087@oksana.dev.rtsoft.ru>
References: <1313910101.15589.0.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1313910101.15589.0.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 21, 2011 at 03:01:41PM +0800, Axel Lin wrote:
> power/s3c_adc_battery:.c uses interfaces from linux/module.h,
> so it should include that file.
> 
> This patch fixes below build error:
> 
>   CC      drivers/power/s3c_adc_battery.o
> drivers/power/s3c_adc_battery.c:435: error: expected declaration specifiers or '...' before string constant
> drivers/power/s3c_adc_battery.c:435: warning: data definition has no type or storage class
> drivers/power/s3c_adc_battery.c:435: warning: type defaults to 'int' in declaration of 'MODULE_AUTHOR'
> drivers/power/s3c_adc_battery.c:435: warning: function declaration isn't a prototype
> drivers/power/s3c_adc_battery.c:436: error: expected declaration specifiers or '...' before string constant
> drivers/power/s3c_adc_battery.c:436: warning: data definition has no type or storage class
> drivers/power/s3c_adc_battery.c:436: warning: type defaults to 'int' in declaration of 'MODULE_DESCRIPTION'
> drivers/power/s3c_adc_battery.c:436: warning: function declaration isn't a prototype
> drivers/power/s3c_adc_battery.c:437: error: expected declaration specifiers or '...' before string constant
> drivers/power/s3c_adc_battery.c:437: warning: data definition has no type or storage class
> drivers/power/s3c_adc_battery.c:437: warning: type defaults to 'int' in declaration of 'MODULE_LICENSE'
> drivers/power/s3c_adc_battery.c:437: warning: function declaration isn't a prototype
> make[2]: *** [drivers/power/s3c_adc_battery.o] Error 1
> make[1]: *** [drivers/power] Error 2
> make: *** [drivers] Error 2
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---

Vasily Khoruzhick sent a similar fix.

I'm going to send a pull request with these fixes soon.

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
