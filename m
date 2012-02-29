Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757597Ab2B2Dtf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 22:49:35 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:37408 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752773Ab2B2Dte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 22:49:34 -0500
X-Sasl-enc: 0kMfaqWmpZeLyFbUQMw2IwejVuRcl8f5/VE/8gDvI0yU 1330487373
Date: Tue, 28 Feb 2012 19:46:32 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: "Oliver N. Baumann" <oliver.n.baumann@googlemail.com>
Cc: sjakub@gmail.com, pq@iki.fi, baumanno@cip.ifi.lmu.de, kernel@kenobrien.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: asus_oled: fix checkpatch.pl issue in
 asus_oled.c
Message-ID: <20120229034632.GA22450@kroah.com>
References: <1330486491-8699-1-git-send-email-baumanno@cip.ifi.lmu.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330486491-8699-1-git-send-email-baumanno@cip.ifi.lmu.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 04:34:51AM +0100, Oliver N. Baumann wrote:
> From: "Oliver N. Baumann" <baumanno@cip.ifi.lmu.de>
> 
> This is a patch to asus_oled.c that fixes a parenthesis issue detected by checkpatch.pl tool
> Signed-off-by: Oliver N. Baumann <baumanno@cip.ifi.lmu.de>

You need a blank line between the changelog text and the signed-off-by
line.

Also, please wrap your changelog entry at 72 columns.

But most of all:

> ---
>  drivers/staging/asus_oled/asus_oled.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/asus_oled/asus_oled.c b/drivers/staging/asus_oled/asus_oled.c
> index 1df9586..b77f225 100644
> --- a/drivers/staging/asus_oled/asus_oled.c
> +++ b/drivers/staging/asus_oled/asus_oled.c
> @@ -44,9 +44,9 @@
>  
>  #define ASUS_OLED_ERROR			"Asus OLED Display Error: "
>  
> -#define ASUS_OLED_STATIC		's'
> -#define ASUS_OLED_ROLL			'r'
> -#define ASUS_OLED_FLASH			'f'
> +#define ASUS_OLED_STATIC		('s')
> +#define ASUS_OLED_ROLL			('r')
> +#define ASUS_OLED_FLASH			('f')

That's not a valid change, checkpatch is being stupid here, please use
your judgement.  This patch changes nothing, go bug the checkpatch
people to fix their tool.

greg k-h
