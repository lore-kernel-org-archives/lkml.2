Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832Ab1BBLd2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 06:33:28 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:61286 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446Ab1BBLd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 06:33:27 -0500
Message-ID: <4D4940E0.8070306@corscience.de>
Date: Wed, 02 Feb 2011 12:32:48 +0100
From: Bernhard Walle <walle@corscience.de>
Organization: Corscience GmbH & Co. KG
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: dbrownell@users.sourceforge.net, grant.likely@secretlab.ca,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH] spi: spidev: Add 32 bit compat ioctl()
References: <1296644235-23933-1-git-send-email-walle@corscience.de> <201102021215.29002.arnd@arndb.de>
In-Reply-To: <201102021215.29002.arnd@arndb.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:z6aPLKLmVYqftezoEoZ162zOIO3W09C+qGKi8phCYKU
 XD5VJMaYSZEm6fCfRsmla6oLBw6PjSf9r5MU3ATuALcvpvbLeZ
 Ow/wdumNoVW4nTUQsgsjXBYCiJTxoNaNL48VNGEcXEeMjKl2l8
 sIxJ/2iLgMIRnryZEYy0IMTlVXpAmapjxag9fwQrU3hFvt2YTG
 bR3+FcH+fqBVoyXwek6jQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 02.02.2011 12:15, schrieb Arnd Bergmann:
> On Wednesday 02 February 2011, Bernhard Walle wrote:
>> Add the compat_ioctl for operations on /dev/spi* so that 32 bit
>> userspace applications can access SPI. As far as I can see all data
>> structure are already prepared for that, so no additional conversion has
>> to be done.
>>
>> My use case is MIPS with N32 userspace ABI and toolchain, and that was
>> also the platform where I tested it successfully (Cavium Octeon).
>>
>> Signed-off-by: Bernhard Walle <walle@corscience.de>
> 
> I think you now need to #include <linux/compat.h> as well, to get the
> definition of compat_ptr(). Otherwise looks good.

It compiled on my MIPS test environment without that include, but I
adjusted the patch and posted again.

Thanks for reviewing, Arnd!


Regards,
Bernhard
