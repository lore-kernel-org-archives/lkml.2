Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757071Ab0I1Jtd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 05:49:33 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:56374 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526Ab0I1Jtb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 05:49:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=JNL+6dP7+Kqt7QPcACQ5OVSx21NVV7EB/7obnNBJ6ZLsLarWL0FelDN34fIj4xWu+I
         Ui6S8sC+qhWe+RjdXXH9iDbGzA2y/vozXeTS/+ab41GKX7wydX4AWKgl4ssRQjBdUe34
         vOIc8UoMgb3YCBWcBMJkUac8K8xNA6DM7AaI8=
MIME-Version: 1.0
In-Reply-To: <1285652796-24558-1-git-send-email-kgene.kim@samsung.com>
References: <1285652796-24558-1-git-send-email-kgene.kim@samsung.com>
Date: Tue, 28 Sep 2010 18:49:29 +0900
X-Google-Sender-Auth: MSQoCuHvm1yEdalWbqizcN5e3fg
Message-ID: <AANLkTinM2+Ap2G___-ynrqe-f9AjUezxNcO8GrFqSKLY@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: Updates maintainer for S5P ARM ARCHITECTURES
From: Kyungmin Park <kmpark@infradead.org>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, ben-linux@fluff.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        rmk@arm.linux.org.uk, Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

Please except the Samsung Mobile Board support.
There are many board or machine support on ARM.

If required, I'll send it separately.

Thank you,
Kyungmin Park

diff --git a/MAINTAINERS b/MAINTAINERS
index ceba39b..537ee18 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -962,6 +962,21 @@ W: http://www.fluff.org/ben/linux/
 S:     Maintained
 F:     arch/arm/mach-s3c6410/

+ARM/S5PC110 AQUILA,GONI SUPPORT
+M:     Kyungmin Park <kyungmin.park@samsung.com>
+M:     Marek Szyprowski <m.szyprowski@samsung.com>
+L:     linux-arm-kernel@lists.infradead.org
+S:     Maintained
+F:     arch/arm/mach-s5pv210/mach-aquila.c
+F:     arch/arm/mach-s5pv210/mach-goni.c
+
+ARM/S5PC210 UNIVERSAL SUPPORT
+M:     Kyungmin Park <kyungmin.park@samsung.com>
+M:     Marek Szyprowski <m.szyprowski@samsung.com>
+L:     linux-arm-kernel@lists.infradead.org
+S:     Maintained
+F:     arch/arm/mach-s5pv310/mach-universal_c210.c

On Tue, Sep 28, 2010 at 2:46 PM, Kukjin Kim <kgene.kim@samsung.com> wrote:
> Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
> Cc: Ben Dooks <ben-linux@fluff.org>
> Cc: Russell King <rmk@arm.linux.org.uk>
> ---
>  MAINTAINERS |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index c36f5d7..acad9b5 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -962,6 +962,13 @@ W: http://www.fluff.org/ben/linux/
>  S:     Maintained
>  F:     arch/arm/mach-s3c6410/
>
> +ARM/S5P ARM ARCHITECTURES
> +M:     Kukjin Kim <kgene.kim@samsung.com>
> +L:     linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
> +L:     linux-samsung-soc@vger.kernel.org (moderated for non-subscribers)
> +S:     Maintained
> +F:     arch/arm/mach-s5p*/
> +
>  ARM/SHMOBILE ARM ARCHITECTURE
>  M:     Paul Mundt <lethal@linux-sh.org>
>  M:     Magnus Damm <magnus.damm@gmail.com>
> --
> 1.6.2.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
