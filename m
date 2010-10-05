Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758092Ab0JEKqn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 06:46:43 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:52994 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173Ab0JEKqm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 06:46:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=a59wbCVkgYeA88hox5WS2JAVaWZf59AYlEq45zpum8Lp9cMw8uCMbEY3UDWLw6Mbkg
         4sU6CbEH/853RwaACQJLEjjbMYg4XbWEqdOnh+KUMwXX/sYVk94BqyoaCqialKNQ86e0
         3x6Ks0gsKEPuw/jj0NrNJKjuTehlmbgTdgeV0=
MIME-Version: 1.0
In-Reply-To: <20101005123402.0d610cfc@absol.kitzblitz>
References: <20101005123402.0d610cfc@absol.kitzblitz>
Date: Tue, 5 Oct 2010 13:46:41 +0300
X-Google-Sender-Auth: IMokLyhVgqB-ek7MZiqYBl55lwc
Message-ID: <AANLkTikJahqhT9xVAXa=tcMuyUzfmVg+4wRMZW3NMwqW@mail.gmail.com>
Subject: Re: [PATCH] x86/mm: remove duplicated include
From: Pekka Enberg <penberg@kernel.org>
To: Nicolas Kaiser <nikai@nikai.net>
Cc: Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 5, 2010 at 1:34 PM, Nicolas Kaiser <nikai@nikai.net> wrote:
> Remove duplicated include.
>
> Signed-off-by: Nicolas Kaiser <nikai@nikai.net>

Acked-by: Pekka Enberg <penberg@kernel.org>

> ---
>  arch/x86/mm/init_64.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> index 9a66746..612f353 100644
> --- a/arch/x86/mm/init_64.c
> +++ b/arch/x86/mm/init_64.c
> @@ -50,7 +50,6 @@
>  #include <asm/numa.h>
>  #include <asm/cacheflush.h>
>  #include <asm/init.h>
> -#include <linux/bootmem.h>
>
>  static unsigned long dma_reserve __initdata;
>
> --
> 1.7.2.2
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
