Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757573Ab2BCUkA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 15:40:00 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:43091 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756389Ab2BCUj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 15:39:59 -0500
Message-ID: <1328301590.18218.8.camel@joe2Laptop>
Subject: Re: [PATCH 1/3] apple_bl: Convert printks to pr_<level>
From: Joe Perches <joe@perches.com>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
        Matthew Garrett <mjg@redhat.com>
Date: Fri, 03 Feb 2012 12:39:50 -0800
In-Reply-To: <1328300884-21551-2-git-send-email-seth.forshee@canonical.com>
References: <1328300884-21551-1-git-send-email-seth.forshee@canonical.com>
	 <1328300884-21551-2-git-send-email-seth.forshee@canonical.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-02-03 at 14:28 -0600, Seth Forshee wrote:
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
[]
> diff --git a/drivers/video/backlight/apple_bl.c b/drivers/video/backlight/apple_bl.c
> @@ -58,9 +53,7 @@ static int intel_chipset_send_intensity(struct backlight_device *bd)
>  {
>  	int intensity = bd->props.brightness;
>  
> -	if (debug)
> -		printk(KERN_DEBUG DRIVER "setting brightness to %d\n",
> -		       intensity);
> +	pr_debug("setting brightness to %d\n", intensity);

You may need to add "#define DEBUG" somewhere for
this to work as you might expect it to.

An "allyesconfig" does effectively add one.


