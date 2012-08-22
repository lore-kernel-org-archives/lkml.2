Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658Ab2HVO2j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 10:28:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33980 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753085Ab2HVO2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 10:28:36 -0400
Date: Wed, 22 Aug 2012 16:28:27 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: =?ISO-8859-15?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>,
        linux-input@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH -next] HID: picoLCD: Add missing #include
 <linux/uaccess.h>
In-Reply-To: <1345581683-2099-1-git-send-email-geert@linux-m68k.org>
Message-ID: <alpine.LNX.2.00.1208221628190.32304@pobox.suse.cz>
References: <1345581683-2099-1-git-send-email-geert@linux-m68k.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Aug 2012, Geert Uytterhoeven wrote:

> m68k/allmodconfig:
> 
> drivers/hid/hid-picolcd_debugfs.c: In function ‘picolcd_debug_reset_write’:
> drivers/hid/hid-picolcd_debugfs.c:54: error: implicit declaration of function ‘copy_from_user’
> drivers/hid/hid-picolcd_debugfs.c: In function ‘picolcd_debug_eeprom_read’:
> drivers/hid/hid-picolcd_debugfs.c:112: error: implicit declaration of function ‘copy_to_user’
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
> http://kisskb.ellerman.id.au/kisskb/buildresult/6990818/
> 
>  drivers/hid/hid-picolcd_debugfs.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/hid/hid-picolcd_debugfs.c b/drivers/hid/hid-picolcd_debugfs.c
> index f2491fa..15c22f2 100644
> --- a/drivers/hid/hid-picolcd_debugfs.c
> +++ b/drivers/hid/hid-picolcd_debugfs.c
> @@ -27,6 +27,7 @@
>  #include <linux/debugfs.h>
>  
>  #include <linux/module.h>
> +#include <linux/uaccess.h>
>  
>  #include "hid-picolcd.h"

Applied, thanks Geert.

-- 
Jiri Kosina
SUSE Labs
