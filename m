Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360Ab1BHCkq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 21:40:46 -0500
Received: from www.wytron.com.tw ([211.75.82.101]:52337 "EHLO
	www.wytron.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755249Ab1BHCkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 21:40:45 -0500
Message-ID: <4D50ADC2.9060304@wytron.com.tw>
Date: Tue, 08 Feb 2011 10:43:14 +0800
From: Thomas Chou <thomas@wytron.com.tw>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Peter Korsgaard <jacmet@sunsite.dk>
CC: David Brownell <dbrownell@users.sourceforge.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org,
        spi-devel-general@lists.sourceforge.net,
        nios2-dev@sopc.et.ntust.edu.tw, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7] spi: New driver for Altera SPI
References: <20110203173430.GC6180@angua.secretlab.ca>	<1296914523-13740-1-git-send-email-thomas@wytron.com.tw> <87aai8zzd1.fsf@macbook.be.48ers.dk>
In-Reply-To: <87aai8zzd1.fsf@macbook.be.48ers.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 192.168.1.15
X-SA-Exim-Mail-From: thomas@wytron.com.tw
X-SA-Exim-Scanned: No (on www.wytron.com.tw); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2011 04:23 AM, Peter Korsgaard wrote:
>>>>>> "Thomas" == Thomas Chou<thomas@wytron.com.tw>  writes:
>
> Hi,
>
>   Thomas>  +++ b/drivers/spi/Kconfig
>   Thomas>  @@ -53,6 +53,13 @@ if SPI_MASTER
>
>   Thomas>   comment "SPI Master Controller Drivers"
>
>   Thomas>  +config SPI_ALTERA
>   Thomas>  +	tristate "Altera SPI Controller"
>   Thomas>  +	default n
>
> 'n' is the default anyway, so no need for this line.
>
Hi Peter,

Thanks. I will remove them.

- Thomas
