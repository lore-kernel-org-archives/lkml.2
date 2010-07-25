Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050Ab0GYP1Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 11:27:25 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61182 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884Ab0GYP1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 11:27:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=gto7aw0vadqNGrzBzSJz2vJa/XyyeZFnK9aMFcYaPnSP6zrjwcchVb0GVDlrSmHkDI
         8Yz9BZLJDfd9OO74QbntN6lUSpqwAeYcNpBUwkdltsCf52Cg0UenC5t/Sh9Jdpormlal
         LEaQdqBpi7k00tFP6Uawy1JlJU1NFrEHG4xfg=
Message-ID: <4C4C57D7.8090804@gmail.com>
Date: Sun, 25 Jul 2010 17:27:19 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.7) Gecko/20100714 SUSE/3.1.1 Thunderbird/3.1.1
MIME-Version: 1.0
To: Michael Jensen <emjay1988@gmail.com>
CC: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: comedi: comedidev: Removed unused macro definitions
References: <1280070874-8961-1-git-send-email-emjay1988@gmail.com>
In-Reply-To: <1280070874-8961-1-git-send-email-emjay1988@gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2010 05:14 PM, Michael Jensen wrote:
> Removed macro definition that wasn't used.
> 
> Signed-off-by: Michael Jensen <emjay1988@gmail.com>
> ---
>  drivers/staging/comedi/comedidev.h |    5 -----
>  1 files changed, 0 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/staging/comedi/comedidev.h b/drivers/staging/comedi/comedidev.h
> index 4eb2b77..b225fff 100644
> --- a/drivers/staging/comedi/comedidev.h
> +++ b/drivers/staging/comedi/comedidev.h
> @@ -61,11 +61,6 @@
>  	module_init(x ## _init_module);					\
>  	module_exit(x ## _cleanup_module);
>  
> -#define COMEDI_MODULE_MACROS						\
> -	MODULE_AUTHOR("Comedi http://www.comedi.org");		\
> -	MODULE_DESCRIPTION("Comedi low-level driver");			\
> -	MODULE_LICENSE("GPL");
> -
>  #define COMEDI_INITCLEANUP(x)						\
>  	COMEDI_MODULE_MACROS		\

As you are removing COMEDI_MODULE_MACROS, it makes sense to remove
COMEDI_INITCLEANUP too.

>  	COMEDI_INITCLEANUP_NOMODULE(x)


-- 
js
