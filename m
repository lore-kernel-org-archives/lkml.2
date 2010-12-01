Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099Ab0LAVBu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 16:01:50 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44180 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755931Ab0LAVBt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 16:01:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CwelXsb4+oeFOTp+qeZtpFC3st0gTpxTBoL4T33lfJ3qUZAWSskjeAmPUnVhc+10ne
         GcohH5Qutbg+FKKLF/4eF9inPbJqnHxOj2/+lICsEmKfclMPWqWZoxgb/TamD3yPqEs5
         q6CEiaFsj7RUJxLSqNC2Njt96uG9d0qyjKvUk=
MIME-Version: 1.0
In-Reply-To: <1291217412-9435-1-git-send-email-ulli.kroll@googlemail.com>
References: <1291217412-9435-1-git-send-email-ulli.kroll@googlemail.com>
Date: Wed, 1 Dec 2010 23:01:47 +0200
Message-ID: <AANLkTi=Myb9=dF0K=EKCeuTcL_kzY4wd+FkDQHYWsZSs@mail.gmail.com>
Subject: Re: [PATCH] Kconfig: add new symbol MIGHT_HAVE_PCI
From: "avictor.za@gmail.com" <avictor.za@gmail.com>
To: Hans Ulli Kroll <ulli.kroll@googlemail.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

>  config PCI
> -       bool "PCI support" if ARCH_INTEGRATOR_AP || ARCH_VERSATILE_PB || ARCH_IXP4XX || ARCH_KS8695 || MACH_ARMCORE || ARCH_CNS3XXX
> +       bool "PCI support" if MIGHT_HAVE_PCI
>        help
>          Find out whether you have a PCI motherboard. PCI is the name of a
>          bus system, i.e. the way the CPU talks to the other stuff inside

This used to enable PCI support for all KS8695-based boards.  (ARCH_KS8695)


> --- a/arch/arm/mach-ks8695/Kconfig
> +++ b/arch/arm/mach-ks8695/Kconfig
> @@ -4,6 +4,7 @@ menu "Kendin/Micrel KS8695 Implementations"
>
>  config MACH_KS8695
>        bool "KS8695 development board"
> +       select MIGHT_HAVE_PCI
>        help
>          Say 'Y' here if you want your kernel to run on the original
>          Kendin-Micrel KS8695 development board.

Where-as this only enables it for the KS8695 Development board (MACH_KS8695)....


Regards.
  Andrew Victor
