Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541Ab2A3XON (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 18:14:13 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:53815 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754262Ab2A3XOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 18:14:09 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: linux-usb@vger.kernel.org
Subject: Re: [PATCH 12/16] kobil_sct: fix debug module parameter to be bool
Date: Tue, 31 Jan 2012 00:13:25 +0100
User-Agent: KMail/1.9.10
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
        Johan Hovold <jhovold@gmail.com>, Jir i Slaby <jslaby@suse.cz>,
        linux-kernel@vger.kernel.org, linuxusb@kobil.de
References: <1327960820-11867-1-git-send-email-danny.kukawka@bisect.de> <1327960820-11867-13-git-send-email-danny.kukawka@bisect.de>
In-Reply-To: <1327960820-11867-13-git-send-email-danny.kukawka@bisect.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201201310013.26307.danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1327965249;4fb3ba76;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Montag, 30. Januar 2012, Danny Kukawka wrote:
> Fix debug variable from module parameter to be really bool to
> fix 'warning: return from incompatible pointer type'.
>
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
> ---
>  drivers/usb/serial/kobil_sct.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/usb/serial/kobil_sct.c
> b/drivers/usb/serial/kobil_sct.c index 5d3beee..a92a3ef 100644
> --- a/drivers/usb/serial/kobil_sct.c
> +++ b/drivers/usb/serial/kobil_sct.c
> @@ -38,7 +38,7 @@
>  #include <linux/ioctl.h>
>  #include "kobil_sct.h"
>
> -static int debug;
> +static bool debug;
>
>  /* Version Information */
>  #define DRIVER_VERSION "21/05/2004"

Forget this one, it's already in linux-next:
http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commitdiff;h=3297f86a3d4158e052538c7b9a3dea9c855a1b42;hp=2492c6e6454ff3edb11e273b071a6ea80a199c71

Danny
