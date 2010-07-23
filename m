Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988Ab0GWIx0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 04:53:26 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39575 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756Ab0GWIxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 04:53:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=Ybym9X8AWTo5R2nyjqSJnrYpHsL70FdOxpTJ1h/TwhJZMXX0x0LM9sRXQYzspvT0Pm
         EmRqbWsTpKkQVyMjQW1GmzsCdPRS+Is7D2i2hr4yc+S2qEXJkKuwmdZum4xCXWa+MDQc
         TAhgMcdJJwmHPrKre6kRCYbk03ulP3dTv8rkk=
Message-ID: <4C495880.2090705@gmail.com>
Date: Fri, 23 Jul 2010 10:53:20 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.4) Gecko/20100608 SUSE/3.1.0 Thunderbird/3.1
MIME-Version: 1.0
To: Michael Jensen <emjay1988@gmail.com>
CC: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: comedi: comedidev: Fixed a macro definition
 code style issue
References: <1279865467-16522-1-git-send-email-emjay1988@gmail.com>
In-Reply-To: <1279865467-16522-1-git-send-email-emjay1988@gmail.com>
X-Enigmail-Version: 1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2010 08:11 AM, Michael Jensen wrote:
> Fixed a code style issue.
> 
> Signed-off-by: Michael Jensen <emjay1988@gmail.com>
> ---
>  drivers/staging/comedi/comedidev.h |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/comedi/comedidev.h b/drivers/staging/comedi/comedidev.h
> index 4eb2b77..a46e859 100644
> --- a/drivers/staging/comedi/comedidev.h
> +++ b/drivers/staging/comedi/comedidev.h
> @@ -61,10 +61,11 @@
>  	module_init(x ## _init_module);					\
>  	module_exit(x ## _cleanup_module);
>  
> -#define COMEDI_MODULE_MACROS						\
> -	MODULE_AUTHOR("Comedi http://www.comedi.org");		\
> +#define COMEDI_MODULE_MACROS		do {				\
> +	MODULE_AUTHOR("Comedi http://www.comedi.org");			\
>  	MODULE_DESCRIPTION("Comedi low-level driver");			\
> -	MODULE_LICENSE("GPL");
> +	MODULE_LICENSE("GPL");						\
> +} while (0)

Hmm, does this compile?

-- 
js
