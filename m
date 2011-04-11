Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756422Ab1DKXgP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 19:36:15 -0400
Received: from kroah.org ([198.145.64.141]:40967 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754023Ab1DKXf6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 19:35:58 -0400
Date: Mon, 11 Apr 2011 16:35:51 -0700
From: Greg KH <greg@kroah.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        George Kashperko <george@znau.edu.ua>, Arnd Bergmann <arnd@arndb.de>,
        Russell King <rmk@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        b43-dev@lists.infradead.org,
        Michael =?iso-8859-1?Q?B=FCsch?= <mb@bu3sch.de>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        Andy Botting <andy@andybotting.com>,
        linux-arm-kernel@lists.infradead.org,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [RFC][PATCH] axi: add AXI bus driver
Message-ID: <20110411233551.GB13240@kroah.com>
References: <1302566227-23788-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1302566227-23788-1-git-send-email-zajec5@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 01:57:07AM +0200, Rafał Miłecki wrote:
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
>     Use DEFINE_PCI_DEVICE_TABLE in bridge
>     Make use of pr_fmt and pr_*
>     Store core class
>     Rename bridge to not b43 specific
>     Replace magic 0x1000 with BCMAI_CORE_SIZE
>     Remove some old "ssb" names and defines
>     Move BCMAI_ADDR_BASE def
>     Add drvdata field
> V3: Fix reloading (kfree issue)
>     Add 14e4:0x4331
>     Fix non-initialized struct issue
>     Drop useless inline functions wrappers for pci core drv
>     Proper pr_* usage
> V3.1: Include forgotten changes (pr_* and include related)
>     Explain why we dare to implement empty release function

Nope, still not allowed, see my other email, sorry.

thanks,

greg k-h
