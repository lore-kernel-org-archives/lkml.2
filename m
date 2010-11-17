Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934518Ab0KQGml (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 01:42:41 -0500
Received: from www.wytron.com.tw ([211.75.82.101]:54281 "EHLO
	www.wytron.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933297Ab0KQGmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 01:42:40 -0500
X-Greylist: delayed 1657 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Nov 2010 01:42:40 EST
Message-ID: <4CE373BC.30805@wytron.com.tw>
Date: Wed, 17 Nov 2010 14:18:36 +0800
From: Thomas Chou <thomas@wytron.com.tw>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Baruch Siach <baruch@tkos.co.il>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Indan Zupancic <indan@nul.nu>, Greg KH <greg@kroah.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Alex Gershgorin <agersh@rambler.ru>
Subject: Re: [PATCHv3] drivers/misc: Altera active serial implementation
References: <fa8a1cda966a356d4c0bfe6e285c01679bf6ef60.1289809182.git.baruch@tkos.co.il>
In-Reply-To: <fa8a1cda966a356d4c0bfe6e285c01679bf6ef60.1289809182.git.baruch@tkos.co.il>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 192.168.1.15
X-SA-Exim-Mail-From: thomas@wytron.com.tw
X-SA-Exim-Scanned: No (on www.wytron.com.tw); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2010 04:23 PM, Baruch Siach wrote:
> From: Alex Gershgorin<agersh@rambler.ru>
>
> The active serial protocol can be used to program Altera serial configuration
> devices. This driver uses the kernel gpio interface to implement the active
> serial protocol.
>
> This patch also introduces the include/platform_drivers/ directory, which is
> the new home for platform data headers. This is per Greg's suggestion.
>

Hi Alex,

Altera EPCS is normal SPI serial flash, which is exactly the same as 
STmicro part. Please consider existing drivers/mtd/devices/m25p80.c and 
drivers/spi/spi_gpio.c.

Best regards,
Thomas
