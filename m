Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098Ab0FECYr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 22:24:47 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39154 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755147Ab0FECYp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 22:24:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=EyE5d8+vQdJbiU8Hpj0ibGVSV1d3iQZKWENFlDYynkc7AcZFxJULXpZltqTU7mZXUF
         hP6i1MzK9ZBprsHGUpdmjPM7/umQFARyOe+38TAvqs7DrF5UkiqpizrI2v37g8IG1DWQ
         rAtCk7BjLhVcvJC6Dq6CekJWDqfLsgid5okbM=
MIME-Version: 1.0
In-Reply-To: <1275647794-30634-2-git-send-email-kgene.kim@samsung.com>
References: <1275647794-30634-1-git-send-email-kgene.kim@samsung.com>
	<1275647794-30634-2-git-send-email-kgene.kim@samsung.com>
Date: Sat, 5 Jun 2010 11:24:44 +0900
X-Google-Sender-Auth: gJlzyiyIqOodEDja0homzoiD5xY
Message-ID: <AANLkTinpth-JO7pIOWXbnuUWXM3xQ1OnFKkfESwi0cP3@mail.gmail.com>
Subject: Re: [PATCH 2/2] MAINTAINERS: add maintainer for SAMSUNG ARM 
	ARCHITECTURES
From: Kyungmin Park <kmpark@infradead.org>
To: ben-linux@fluff.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Kukjin Kim <kgene.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

I'm waiting your comments.

Thank you,
Kyungmin Park

On Fri, Jun 4, 2010 at 7:36 PM, Kukjin Kim <kgene.kim@samsung.com> wrote:
> Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
> ---
>  MAINTAINERS |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 1d41149..f4e4c61 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -896,11 +896,13 @@ S:        Maintained
>
>  ARM/SAMSUNG ARM ARCHITECTURES
>  M:     Ben Dooks <ben-linux@fluff.org>
> +M:     Kukjin Kim <kgene.kim@samsung.com>
>  L:     linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
>  W:     http://www.fluff.org/ben/linux/
>  S:     Maintained
>  F:     arch/arm/plat-samsung/
>  F:     arch/arm/plat-s3c24xx/
> +F:     arch/arm/plat-s5p/
>
>  ARM/S3C2410 ARM ARCHITECTURE
>  M:     Ben Dooks <ben-linux@fluff.org>
> --
> 1.6.2.5
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>
