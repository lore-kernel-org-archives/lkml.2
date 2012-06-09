Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371Ab2FIM5Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 08:57:24 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:40340 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753389Ab2FIM5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 08:57:22 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX19kkVATRsJk/XzwzlmWZivu67CCpaldvbVdEBY9EB
	XcdpTn2zpfKOQb
Message-ID: <4FD3482B.5050004@gmx.de>
Date: Sat, 09 Jun 2012 12:57:15 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120506 Icedove/3.0.11
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: mathieu.poirier@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        unsik Kim <donari75@gmail.com>
Subject: Re: [PATCH 0/6] drivers: randconfig patches for kernel 3.5
References: <1339194280-27475-1-git-send-email-mathieu.poirier@linaro.org> <201206090013.27149.arnd@arndb.de>
In-Reply-To: <201206090013.27149.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd, Mathieu,

On 06/09/2012 12:13 AM, Arnd Bergmann wrote:
> On Friday 08 June 2012, mathieu.poirier@linaro.org wrote:
>> From: Mathieu Poirier <mathieu.poirier@linaro.org>
>>
>> These patches fix miscellaneous problems when working
>> with make randconfig.  They were discovered on kernel
>> 3.1-rc4 and sent out during the 3.4 cycle but were not
>> ack'ed.  
>>
>> Sending out again for completeness.
> 
> Hi Mathieu,
> 
> I just realized that most of these are for the same subsystem
> (framebuffer), so you should have kept the respective mailing list
> and maintainer on Cc (added now). 
> 
> The mg_disk driver is not listed in the MAINTAINERS file but
> has an author email listed in the file itself.
> 
> I can take the mg_disk patch into the arm-soc tree as a fix,
> but I'd prefer the other patches to go through the framebuffer
> tree.

Applied all (including the backlight patches which are usually handled
by Andrew Morton) but the mg_disk patch.


Thanks,

Florian Tobias Schandinat

> 
> 	Arnd
> 
>> Arnd Bergmann (6):
>>   drivers/video: use correct __devexit_p annotation
>>   mg_disk: use readb/writeb instead of inb/outb
>>   video/ili9320: do not mark exported functions __devexit
>>   video/console: automatically select a font
>>   drivers/savagefb: use mdelay instead of udelay
>>   drivers/tosa: driver needs I2C and SPI to compile
>>
>>  drivers/block/mg_disk.c                |   78 ++++++++++++++++----------------
>>  drivers/video/backlight/Kconfig        |    2 +-
>>  drivers/video/backlight/ili9320.c      |    2 +-
>>  drivers/video/broadsheetfb.c           |    2 +-
>>  drivers/video/console/Kconfig          |   14 ++++++
>>  drivers/video/mbx/mbxfb.c              |    2 +-
>>  drivers/video/savage/savagefb_driver.c |   10 ++--
>>  7 files changed, 62 insertions(+), 48 deletions(-)
> 

