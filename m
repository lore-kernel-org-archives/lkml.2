Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964Ab0DZFBF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 01:01:05 -0400
Received: from mail.perches.com ([173.55.12.10]:1728 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751427Ab0DZFBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 01:01:03 -0400
Subject: Re: [PATCH] Staging: comedi: fixed coding style issues in drivers.c
From: Joe Perches <joe@perches.com>
To: zr.public@gmail.com
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
In-Reply-To: <1272203891-15546-1-git-send-email-zr.public@gmail.com>
References: <1272203891-15546-1-git-send-email-zr.public@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 25 Apr 2010 22:01:00 -0700
Message-ID: <1272258060.15953.58.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-04-25 at 09:58 -0400, zr.public@gmail.com wrote:
> From: Zachary_r <zr.public@gmail.com>
> @@ -123,8 +123,8 @@ int comedi_device_attach(struct comedi_device *dev, struct comedi_devconfig *it)
>  
>  	for (driv = comedi_drivers; driv; driv = driv->next) {
>  		if (!try_module_get(driv->module)) {
> -			printk
> -			    ("comedi: failed to increment module count, skipping\n");
> +			printk(KERN_INFO "comedi: failed to increment\
> +			module count, skipping\n");

Using line continuations like this is incorrect.
There are many uses like this in your proposed patch.

It adds the initial whitespace on the continued line
to the string constant.

Except for macro definitions, linux doesn't generally
use line continuations.

There's no attempt to keep line numbers consistent
across multiple versions.

cheers, Joe

