Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035Ab0GOGq6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 02:46:58 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33163 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160Ab0GOGq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 02:46:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=x4HIowGl1Df+WJMKM5eQ4Pe2WWXUJl3BFcgHnYOJK8goEWr+B1r4YmtpHTw8DWriLR
         Xb5Db0HAfvDk8zAQTJcoYVPzxGQnXD6xnhFm8veEYVMfx+yjaOpuAJiJ+48JHshzFbBP
         sPpebx9PuAsqbq+mnEzsZgCGPMGUAPNi53KLs=
Message-ID: <4C3EAEC5.8080908@gmail.com>
Date: Thu, 15 Jul 2010 08:46:29 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.4) Gecko/20100608 SUSE/3.1.0 Thunderbird/3.1
MIME-Version: 1.0
To: Kulikov Vasiliy <segooon@gmail.com>
CC: kernel-janitors@vger.kernel.org, devel@driverdev.osuosl.org,
        Javier Martinez Canillas <martinez.javier@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Alexander Kurz <linux@kbdbabel.org>
Subject: Re: [PATCH 09/11] staging: comedi: formatting of pointers in printk()
References: <1279176172-5609-1-git-send-email-segooon@gmail.com>
In-Reply-To: <1279176172-5609-1-git-send-email-segooon@gmail.com>
X-Enigmail-Version: 1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2010 08:42 AM, Kulikov Vasiliy wrote:
> Use %p instead of %08x in printk().
> 
> Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
> ---
>  drivers/staging/comedi/drivers/quatech_daqp_cs.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/comedi/drivers/quatech_daqp_cs.c b/drivers/staging/comedi/drivers/quatech_daqp_cs.c
> index 8d16380..8b49cb1 100644
> --- a/drivers/staging/comedi/drivers/quatech_daqp_cs.c
> +++ b/drivers/staging/comedi/drivers/quatech_daqp_cs.c
> @@ -208,7 +208,7 @@ static void hex_dump(char *str, void *ptr, int len)

The name and parameters suggest to remove the function completely. (And
use print_hex_dump_bytes instead.)

>  
>  	for (i = 0; i < len; i++) {
>  		if (i % 16 == 0)
> -			printk("\n0x%08x:", (unsigned int)cptr);
> +			printk("\n%p:", cptr);
>  
>  		printk(" %02x", *(cptr++));
>  	}


-- 
js
