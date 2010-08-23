Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873Ab0HWNK4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 09:10:56 -0400
Received: from cantor.suse.de ([195.135.220.2]:38072 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751480Ab0HWNKx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 09:10:53 -0400
Date: Mon, 23 Aug 2010 15:10:52 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Thomas Weber <weber@corscience.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix typo in Kconfig help text
In-Reply-To: <1282555234-3196-1-git-send-email-weber@corscience.de>
Message-ID: <alpine.LNX.2.00.1008231510410.1019@pobox.suse.cz>
References: <1282555234-3196-1-git-send-email-weber@corscience.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Aug 2010, Thomas Weber wrote:

> Fix the name of the sensor: BMP086 => BMP085
> 
> Signed-off-by: Thomas Weber <weber@corscience.de>
> ---
>  drivers/misc/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> index 0b591b6..9df5b75 100644
> --- a/drivers/misc/Kconfig
> +++ b/drivers/misc/Kconfig
> @@ -385,7 +385,7 @@ config BMP085
>  	depends on I2C && SYSFS
>  	help
>  	  If you say yes here you get support for the Bosch Sensortec
> -	  BMP086 digital pressure sensor.
> +	  BMP085 digital pressure sensor.
>  
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called bmp085.

Seems correct, applied, thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
