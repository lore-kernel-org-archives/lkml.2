Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612Ab0GNJY6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 05:24:58 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:42221 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190Ab0GNJY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 05:24:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Eisp/R8livkrVa8EWLVOw41QgGRgrIQ0S8yB0Hx0VGKuru/mkpDgsU00flwqpCUHbn
         uwjh5oMCe7OM42K9n1fq1jYNmgTOVltrMn1Hbf2Zh63nY4bswFwJxVMXg4FwhdEM+c5L
         tupsu0B+tYgMkNebuBndMAzUOOCG6vBfKMHVc=
Date: Wed, 14 Jul 2010 13:24:51 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Dajun Chen <dajun.chen@gmail.com>
Cc: dwmw2@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 4/11] Power:Battery module of DA9052 PMIC device
 driver
Message-ID: <20100714092451.GA2242@oksana.dev.rtsoft.ru>
References: <AANLkTikjGNceWZr3IsO8cqKlulDTrEuAQTWH6lB_kSmJ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <AANLkTikjGNceWZr3IsO8cqKlulDTrEuAQTWH6lB_kSmJ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 10:04:11AM +0100, Dajun Chen wrote:
> Battery module of the device driver for DA9052 PMIC device from Dialog
> Semiconductor.
> 
> Changes made since last submission:
> . code has been reorganised as per the standard linux kernel driver
> framework
> . removal of redundant printk and comments
> . removal of test framework
> 
> Linux Kernel Version: 2.6.34
> 
> Signed-off-by: D. Chen <dchen@diasemi.com>
> ---
> diff -urpN linux-2.6.34/drivers/power/da9052_battery.c
> linux-2.6.34_test/drivers/power/da9052_battery.c
> --- linux-2.6.34/drivers/power/da9052_battery.c 1970-01-01
> 05:00:00.000000000 +0500
> +++ linux-2.6.34_test/drivers/power/da9052_battery.c 2010-07-13
> 17:49:01.000000000 +0500
> @@ -0,0 +1,1377 @@

The patch is line wrapped.

> +static int da9052_read(struct da9052 *da9052, u8 reg_address, u8 *reg_data)
> +{
> + struct da9052_ssc_msg msg;
> + int ret;
> +

And whitespace broken.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
