Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933221Ab0LTVJj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 16:09:39 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41798 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933068Ab0LTVJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 16:09:38 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH 1/2] PM: Prototype the pm_generic_ operations
Date: Mon, 20 Dec 2010 22:08:58 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc6+; KDE/4.4.4; x86_64; ; )
Cc: Ben Dooks <ben-linux@fluff.org>, Alan Stern <stern@rowland.harvard.edu>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@lists.linux-foundation.org,
        patches@opensource.wolfsonmicro.com
References: <1292855593-30608-1-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1292855593-30608-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201012202208.59102.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, December 20, 2010, Mark Brown wrote:
> The pm_generic_ operations are all exported but are not prototyped in any
> header file for direct use. Do so.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

I'd take this one, but the second one depends on it.

I can take both if Jean agrees.

Thanks,
Rafael


> ---
>  include/linux/pm.h |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/pm.h b/include/linux/pm.h
> index 40f3f45..f7b5bed 100644
> --- a/include/linux/pm.h
> +++ b/include/linux/pm.h
> @@ -610,4 +610,11 @@ extern unsigned int	pm_flags;
>  #define PM_APM	1
>  #define PM_ACPI	2
>  
> +int pm_generic_suspend(struct device *dev);
> +int pm_generic_resume(struct device *dev);
> +int pm_generic_freeze(struct device *dev);
> +int pm_generic_thaw(struct device *dev);
> +int pm_generic_restore(struct device *dev);
> +int pm_generic_poweroff(struct device *dev);
> +
>  #endif /* _LINUX_PM_H */
> 

