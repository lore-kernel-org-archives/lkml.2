Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716Ab1EHMs3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 08:48:29 -0400
Received: from server19320154104.serverpool.info ([193.201.54.104]:36273 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751325Ab1EHMsY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 08:48:24 -0400
Message-ID: <4DC6910F.2020008@hauke-m.de>
Date: Sun, 08 May 2011 14:48:15 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        b43-dev@lists.infradead.org, Greg KH <greg@kroah.com>,
        =?UTF-8?B?TWljaGFl?= =?UTF-8?B?bCBCw7xzY2g=?= <mb@bu3sch.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        George Kashperko <george@znau.edu.ua>,
        Arend van Spriel <arend@broadcom.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <rmk@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Andy Botting <andy@andybotting.com>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][WAS:bcmai,axi] bcma: add Broadcom specific AMBA bus driver
References: <1304632783-8781-1-git-send-email-zajec5@gmail.com>
In-Reply-To: <1304632783-8781-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2011 11:59 PM, Rafał Miłecki wrote:
.....
> --- /dev/null
> +++ b/drivers/bcma/bcma_private.h
.....
> +
> +#define BCMA_ADDR_BASE		0x18000000
> +#define BCMA_WRAP_BASE		0x18100000
> +
......
> --- /dev/null
> +++ b/drivers/bcma/scan.h
> @@ -0,0 +1,56 @@
> +#ifndef BCMA_SCAN_H_
> +#define BCMA_SCAN_H_
> +
> +#define BCMA_ADDR_BASE		0x18000000
> +#define BCMA_WRAP_BASE		0x18100000
> +
.....

While graping through the code I found this. BCMA_ADDR_BASE and
BCMA_WRAP_BASE are defined twice.

Why are some constants defined in purpose specific headers in
drivers/bcma/*.h like drivers/bcma/scan.h and some in
drivers/bcma/bcma_private.h and other in include/linux/bcma/bcma_regs.h ?

Hauke
