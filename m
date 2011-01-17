Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647Ab1AQGUM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 01:20:12 -0500
Received: from www.wytron.com.tw ([211.75.82.101]:60723 "EHLO
	www.wytron.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316Ab1AQGUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 01:20:10 -0500
Message-ID: <4D33E00E.5050802@wytron.com.tw>
Date: Mon, 17 Jan 2011 14:22:06 +0800
From: Thomas Chou <thomas@wytron.com.tw>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: David Brownell <dbrownell@users.sourceforge.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        nios2-dev@sopc.et.ntust.edu.tw, Mike Frysinger <vapier@gentoo.org>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH v2] spi: New driver for Altera SPI
References: <1254981838-20584-1-git-send-email-thomas@wytron.com.tw>	<1295243200-28230-1-git-send-email-thomas@wytron.com.tw> <20110117165958.f89e8220.sfr@canb.auug.org.au>
In-Reply-To: <20110117165958.f89e8220.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 192.168.1.15
X-SA-Exim-Mail-From: thomas@wytron.com.tw
X-SA-Exim-Scanned: No (on www.wytron.com.tw); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2011 01:59 PM, Stephen Rothwell wrote:
>> +/*
>> + * struct altera_spi_platform_data - platform data of the Altera SPI
>> + * @interrupt:	use intrrupt driven data transfer.
>> + */
>> +struct altera_spi_platform_data {
>> +	int interrupt;
>> +};
>
> Is there some reason that this struct definition cannot just be placed
> in spi_altera.c and so save a whole extra file (and its inclusion)?
>

Hi Stephen,

It is needed for board configuration file to attach this platform data, 
which is used to choose between interrupt driven data transfer or 
polling method. The data transfer rate is usually faster for polling, as 
interrupt overhead is higher.

Best regards,
Thomas

