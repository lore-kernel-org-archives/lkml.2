Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644Ab1KNDjq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 22:39:46 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:56673 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751035Ab1KNDjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 22:39:45 -0500
Subject: Re: [PATCH] [TRIVIAL] unicore32: Fix typo 'PUV3_I2C'
From: Guan Xuetao <gxt@mprc.pku.edu.cn>
Reply-To: gxt@mprc.pku.edu.cn
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Jiri Kosina <trivial@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1321145003.20271.36.camel@x61.thuisdomein>
References: <1321145003.20271.36.camel@x61.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
Organization: MPRC, PKU
Date: Mon, 14 Nov 2011 11:30:59 +0800
Message-ID: <1321241459.1867.16.camel@epip-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-11-13 at 01:43 +0100, Paul Bolle wrote:
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Acked-by: Guan Xuetao <gxt@mprc.pku.edu.cn>

Thanks Paul, and I have pushed this patch into my repo.

Guan Xuetao

> ---
> 0) This corrects an obvious typo. It is untested.
> 
> 1) This could influence the code generated for "I2C Battery BQ27200
> Support" and for "I2C EEPROMs AT24 support". So I've CC'd the people
> involved in commit fa7499ef77 ("unicore32 machine related files: core
> files"), which introduced this typo, to actually test this.
> 
>  arch/unicore32/Kconfig |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/unicore32/Kconfig b/arch/unicore32/Kconfig
> index e57dcce..942ed61 100644
> --- a/arch/unicore32/Kconfig
> +++ b/arch/unicore32/Kconfig
> @@ -237,13 +237,13 @@ menu "PKUnity NetBook-0916 Features"
>  
>  config I2C_BATTERY_BQ27200
>  	tristate "I2C Battery BQ27200 Support"
> -	select PUV3_I2C
> +	select I2C_PUV3
>  	select POWER_SUPPLY
>  	select BATTERY_BQ27x00
>  
>  config I2C_EEPROM_AT24
>  	tristate "I2C EEPROMs AT24 support"
> -	select PUV3_I2C
> +	select I2C_PUV3
>  	select MISC_DEVICES
>  	select EEPROM_AT24
>  


