Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab1DLNEw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 09:04:52 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:37443 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502Ab1DLNEu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 09:04:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xiO0Jn72QZjTNlZVZhiIlJveWcOSVApKL2iu8F3tVZmu8ymYvbHWaJ8SOBxowFkz48
         Ld3BTyYaqrc8AF8yhknUh+B/comHv357OLPI5pZjEl1dO949Nraz5cbTqkRfYCIdZeLc
         l9Y8zwDDElXlAHPP0Gw7UmFmm/dwxY9AqWTLQ=
MIME-Version: 1.0
In-Reply-To: <1302566227-23788-1-git-send-email-zajec5@gmail.com>
References: <1302566227-23788-1-git-send-email-zajec5@gmail.com>
Date: Tue, 12 Apr 2011 15:04:48 +0200
Message-ID: <BANLkTi=jV12tOR_=idn0z+oO_RQ2xaFhCQ@mail.gmail.com>
Subject: Re: [RFC][PATCH] axi: add AXI bus driver
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        =?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        George Kashperko <george@znau.edu.ua>,
        Arend van Spriel <arend@broadcom.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <rmk@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Andy Botting <andy@andybotting.com>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/12 Rafał Miłecki <zajec5@gmail.com>:
> Cc: Michael Büsch <mb@bu3sch.de>
> Cc: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: George Kashperko <george@znau.edu.ua>
> Cc: Arend van Spriel <arend@broadcom.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: Russell King <rmk@arm.linux.org.uk>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Andy Botting <andy@andybotting.com>
> Cc: linuxdriverproject <devel@linuxdriverproject.org>
> Cc: linux-kernel@vger.kernel.org <linux-kernel@vger.kernel.org>
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
> V2: Rename to axi
>    Use DEFINE_PCI_DEVICE_TABLE in bridge
>    Make use of pr_fmt and pr_*
>    Store core class
>    Rename bridge to not b43 specific
>    Replace magic 0x1000 with BCMAI_CORE_SIZE
>    Remove some old "ssb" names and defines
>    Move BCMAI_ADDR_BASE def
>    Add drvdata field
> V3: Fix reloading (kfree issue)
>    Add 14e4:0x4331
>    Fix non-initialized struct issue
>    Drop useless inline functions wrappers for pci core drv
>    Proper pr_* usage
> V3.1: Include forgotten changes (pr_* and include related)
>    Explain why we dare to implement empty release function

There is one more change I started to consider. Is "core" correct name
for AXI's device? Almost everywhere we can read about *components* on
the AXI interconnect.

Maybe it'd make sense to s/core/comp/? Arend?

-- 
Rafał
