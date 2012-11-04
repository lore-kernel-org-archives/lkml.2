Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447Ab2KDRr3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 12:47:29 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:55769 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108Ab2KDRrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 12:47:24 -0500
Date: Sun, 4 Nov 2012 09:47:13 -0800
From: Jonathan Nieder <jrnieder@gmail.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Corentin Chary <corentincj@iksaif.net>, Matthew Garrett <mjg@redhat.com>,
        linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        Alessandro Crismani <alessandro.crismani@gmail.com>,
        Mikhail Bakhterev <mike.bakhterev@gmail.com>,
        Patrick H <kernel@feystorm.net>, Matt Fleming <matt.fleming@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, stable@vger.kernel.org
Subject: Re: [PATCH] samsung-laptop: Disable if CONFIG_EFI=y
Message-ID: <20121104174713.GA28414@elie.Belkin>
References: <1352050506-29317-1-git-send-email-matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352050506-29317-1-git-send-email-matt@console-pimps.org>
User-Agent: Mutt/1.5.21+51 (9e756d1adb76) (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Fleming wrote:

> --- a/drivers/platform/x86/Kconfig
> +++ b/drivers/platform/x86/Kconfig
> @@ -717,7 +717,7 @@ config XO15_EBOOK
> 
>  config SAMSUNG_LAPTOP
>  	tristate "Samsung Laptop driver"
> -	depends on X86
> +	depends on X86 && !EFI

That means distros would just not get the samsung-laptop driver.
Is there a runtime check that could be used instead?

Thanks,
Jonathan
