Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933470Ab2BBWIf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 17:08:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37791 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933446Ab2BBWId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 17:08:33 -0500
Date: Thu, 2 Feb 2012 14:08:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Meerwald <pmeerw@pmeerw.net>
Cc: linux-kernel@vger.kernel.org, rpurdie@rpsys.net, lars@metafoo.de,
        Peter Meerwald <p.meerwald@bct-electronic.com>
Subject: Re: [PATCH] add LED driver for PCA9663 I2C chip
Message-Id: <20120202140831.457ce732.akpm@linux-foundation.org>
In-Reply-To: <1328218873-6469-1-git-send-email-pmeerw@pmeerw.net>
References: <1328218873-6469-1-git-send-email-pmeerw@pmeerw.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  2 Feb 2012 22:41:13 +0100
Peter Meerwald <pmeerw@pmeerw.net> wrote:

> From: Peter Meerwald <p.meerwald@bct-electronic.com>
> 
> simple driver for the PCA9633 I2C chip supporting four LEDs and
> 255 brightness levels
> 
>
> ...
>
> +
> +	pca9633 = kcalloc(sizeof(*pca9633) * 4, GFP_KERNEL);

err,

--- a/drivers/leds/leds-pca9633.c~drivers-leds-add-driver-for-pca9663-i2c-chip-fix
+++ a/drivers/leds/leds-pca9633.c
@@ -110,7 +110,7 @@ static int __devinit pca9633_probe(struc
 		}
 	}
 
-	pca9633 = kcalloc(sizeof(*pca9633) * 4, GFP_KERNEL);
+	pca9633 = kcalloc(sizeof(*pca9633), 4, GFP_KERNEL);
 	if (!pca9633)
 		return -ENOMEM;
 
>
> ...
>
