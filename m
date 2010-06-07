Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109Ab0FGThT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 15:37:19 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:40044 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603Ab0FGThR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 15:37:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=NLEi7ZhvmhdHxLEH1YzGHXKU7cFt2eVzly8pEzeuQ47SzbK4Ihq4/dMdLOk5PypJkN
         L7qbaNYodX62ozfFJYteyNo5cDEZERGTEgiZZryIhYOdfULlvfT7++sCldakY3BrbqL7
         nRFB+AW948WE+Vooa47x0URvKaNgy7UYheMPk=
MIME-Version: 1.0
In-Reply-To: <1275892191.3501.17.camel@balakrishnan-desktop>
References: <1275371058.7001.35.camel@balakrishnan-desktop>
	<201006051919.17738.marek.vasut@gmail.com>
	<AANLkTil5TWYILcdp872as8S8LMqQWhPYWLt7cxs2lUm5@mail.gmail.com>
	<201006061834.50297.marek.vasut@gmail.com>
	<1275892191.3501.17.camel@balakrishnan-desktop>
Date: Mon, 7 Jun 2010 22:37:16 +0300
Message-ID: <AANLkTinKc9Uc6QeKYogK3h1kHsOU1p6Qp1kWgn0J8cMA@mail.gmail.com>
Subject: Re: pxa300 - DDRAM base value
From: Mike Rapoport <mike.rapoport@gmail.com>
To: balakrishnan <balakrishnan@e-consystems.com>
Cc: Marek Vasut <marek.vasut@gmail.com>,
       Maharajan <maharajan@e-consystems.com>,
       Eric Miao <eric.y.miao@gmail.com>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> hi,
>       Now, I can able to boot after editing following files
> arch/arm/mach-pxa/Makefile.boot and arch/arm/mach/pxa/include/mach/memory.h
> (0x80000000 changed to 0xa0000000). My doubt is
> 1.why 0x80000000 (DDR phy address) is aliased to 0xa0000000 in pxa
> architecture?
> 2.In my development board two DDRAMs mapped at 0x80000000-0x88000000 and
> 0xc0000000-0xc8000000, how can I inform to kernel about this different bank
> and size?.

enable CONFIG_HIGHMEM

> My Boot loader details,
> ------------------------------
> =>bdi
> arch_number = 0x00000B04
> env_t       = 0x00000000
> boot_params = 0x80000100
> DRAM bank   = 0x00000000
> -> start    = 0x80000000
> -> size     = 0x08000000
> DRAM bank   = 0x00000001
> -> start    = 0xC0000000
> -> size     = 0x08000000
> ethaddr     = 08:00:3e:26:0a:5b
> ip_addr     = 192.168.0.21
> baudrate    = 115200 bps
> =>ver
> U-Boot 2010.03 (Jun 01 2010 - 14:27:43)
>
>
> With Thanks
> J.Balakrishnan
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>
>



-- 
	Sincerely Yours,
		Mike.
