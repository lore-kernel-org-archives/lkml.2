Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367Ab0DLXxU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 19:53:20 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:49841 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754318Ab0DLXxT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 19:53:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=blM41gfhTHzzoG2oPskOVMgsXe78J6anf9GJ2qtRrUaS6phR1HgCuHspB/kRrLHobY
         j+wrTNjBHN5jFmGu8g2dFsqZHDR2sNoV495+WTajuOAvQxQNnJAXDnIlVAn43UUETPDe
         chTBi9C0jXJq8/ApddiS5FZmD/iFsxA8Xxmv8=
MIME-Version: 1.0
In-Reply-To: <1271102450.2131.27.camel@Joe-Laptop.home>
References: <cover.1269655208.git.joe@perches.com>
	 <0c97f736400ec243e71ba794ae7046a61d2449c1.1269655208.git.joe@perches.com>
	 <20100412194737.GS3048@n2100.arm.linux.org.uk>
	 <1271102450.2131.27.camel@Joe-Laptop.home>
Date: Tue, 13 Apr 2010 08:53:16 +0900
X-Google-Sender-Auth: 6773bcf16a8914f6
Message-ID: <h2p9c9fda241004121653te938caa2u42e39c31f27e85e1@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: arch/arm/s3c and arch/arm/s5p
From: Kyungmin Park <kmpark@infradead.org>
To: Joe Perches <joe@perches.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Ben Dooks <ben-linux-arm@fluff.org>,
       Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Apr 13, 2010 at 5:00 AM, Joe Perches <joe@perches.com> wrote:
> On Mon, 2010-04-12 at 20:47 +0100, Russell King - ARM Linux wrote:
>> This is Samsung stuff, it should be copied to Ben (added).
>
> Maybe this is appropriate?

No, s5p stubs are maintained by Samsung.
Of course Ben work on core part together, e.g., clock, interrupt.

Most s5pc1XX are done by Marek and Kyungmin Park except plat-samsung.
common part of Samsung SoCs.

Thank you,
Kyungmin Park

>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  MAINTAINERS |   40 ++++++++--------------------------------
>  1 files changed, 8 insertions(+), 32 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 7a9ccda..5a0d6ef 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -902,48 +902,24 @@ W:        http://www.fluff.org/ben/linux/
>  S:     Maintained
>  F:     arch/arm/plat-s3c/
>  F:     arch/arm/plat-s3c24xx/
> +F:     arch/arm/plat-samsung/
>
> -ARM/S3C2410 ARM ARCHITECTURE
> +ARM/S3Cxxxx ARM ARCHITECTURE
>  M:     Ben Dooks <ben-linux@fluff.org>
>  L:     linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
>  W:     http://www.fluff.org/ben/linux/
>  S:     Maintained
> -F:     arch/arm/mach-s3c2410/
> -
> -ARM/S3C2440 ARM ARCHITECTURE
> -M:     Ben Dooks <ben-linux@fluff.org>
> -L:     linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
> -W:     http://www.fluff.org/ben/linux/
> -S:     Maintained
> -F:     arch/arm/mach-s3c2440/
> -
> -ARM/S3C2442 ARM ARCHITECTURE
> -M:     Ben Dooks <ben-linux@fluff.org>
> -L:     linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
> -W:     http://www.fluff.org/ben/linux/
> -S:     Maintained
> -F:     arch/arm/mach-s3c2442/
> -
> -ARM/S3C2443 ARM ARCHITECTURE
> -M:     Ben Dooks <ben-linux@fluff.org>
> -L:     linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
> -W:     http://www.fluff.org/ben/linux/
> -S:     Maintained
> -F:     arch/arm/mach-s3c2443/
> -
> -ARM/S3C6400 ARM ARCHITECTURE
> -M:     Ben Dooks <ben-linux@fluff.org>
> -L:     linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
> -W:     http://www.fluff.org/ben/linux/
> -S:     Maintained
> -F:     arch/arm/mach-s3c6400/
> +F:     arch/arm/mach-s3c????/
> +F:     arch/arm/plat-s3c????/
>
> -ARM/S3C6410 ARM ARCHITECTURE
> +ARM/S5Pxxxx ARM ARCHITECTURE
>  M:     Ben Dooks <ben-linux@fluff.org>

It should be Byungho Min but now changed to Marek and Kyungmin Park

>  L:     linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
>  W:     http://www.fluff.org/ben/linux/
>  S:     Maintained
> -F:     arch/arm/mach-s3c6410/
> +F:     arch/arm/mach-s5p????/
> +F:     arch/arm/plat-s5p/
> +F:     arch/arm/plat-s5p????/
>
>  ARM/SHMOBILE ARM ARCHITECTURE
>  M:     Paul Mundt <lethal@linux-sh.org>
>
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>
