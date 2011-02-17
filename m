Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab1BQHwC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 02:52:02 -0500
Received: from symlink.to.noone.org ([85.10.207.172]:52294 "EHLO sym.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034Ab1BQHv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 02:51:57 -0500
Date: Thu, 17 Feb 2011 08:51:56 +0100
From: Tobias Klauser <tklauser@distanz.ch>
To: Thomas Chou <thomas@wytron.com.tw>
Cc: nios2-dev@sopc.et.ntust.edu.tw, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Nios2-dev] [PATCH 4/4] MAINTAINERS: Add myself as a
	maintainer for  altera_uart/altera_jtaguart
Message-ID: <20110217075156.GH4076@distanz.ch>
References: <cover.1297245277.git.tklauser@distanz.ch> <04c107d8032cbaffada91066c1d010b9274aebe1.1297245277.git.tklauser@distanz.ch> <4D5C9314.8030101@wytron.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D5C9314.8030101@wytron.com.tw>
X-Editor: Vi IMproved 7.1
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas

On 2011-02-17 at 04:16:36 +0100, Thomas Chou <thomas@wytron.com.tw> wrote:
> On 02/09/2011 05:58 PM, Tobias Klauser wrote:
>> Signed-off-by: Tobias Klauser<tklauser@distanz.ch>
>> ---
>>   MAINTAINERS |   10 ++++++++++
>>   1 files changed, 10 insertions(+), 0 deletions(-)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index ecef0f1..4e86a11 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -465,6 +465,16 @@ M:	Matt Turner<mattst88@gmail.com>
>>   L:	linux-alpha@vger.kernel.org
>>   F:	arch/alpha/
>>
>> +ALTERA UART/JTAG UART SERIAL DRIVERS
>> +M:	Tobias Klauser<tklauser@distanz.ch>
>> +L:	linux-serial@vger.kernel.org
>> +L:	nios2-dev@sopc.et.ntust.edu.tw (moderated for non-subscribers)
>> +S:	Maintained
>> +F:	drivers/tty/serial/altera_uart.c
>> +F:	drivers/tty/serial/altera_jtaguart.c
>> +F:	include/linux/altera_uart.h
>> +F:	include/linux/altera_jtaguart.h
>> +
>>   AMD GEODE CS5536 USB DEVICE CONTROLLER DRIVER
>>   M:	Thomas Dahlmann<dahlmann.thomas@arcor.de>
>>   L:	linux-geode@lists.infradead.org (moderated for non-subscribers)
>
> Hi Tobias,
>
> As we get more drivers merged into mainline, we might consider adding a  
> general entry for all altera related drivers to our mailing list. We  
> could add "F: arch/nios2" to this entry in the near future.

That's great. I didn't know about the K: section entry.

I will send a patch as below.

> 1) subject: MAINTAINERS: add Altera related drivers entry
> send this to Andrew Morton.
>
> ALTERA EMBEDDED ARCH AND PERIPHERALS DRIVERS
> L:	nios2-dev@sopc.et.ntust.edu.tw (moderated for non-subscribers)
> S:	Maintained
> K:	altera
>
> 2) subject: MAINTAINERS: add Altera UART/JTAG UART maintainer
>
> ALTERA UART/JTAG UART SERIAL DRIVERS
> M:	Tobias Klauser <tklauser@distanz.ch>
> L:	linux-serial@vger.kernel.org
> S:	Maintained
> F:	drivers/tty/serial/altera_uart.c
> F:	drivers/tty/serial/altera_jtaguart.c
> F:	include/linux/altera_uart.h
> F:	include/linux/altera_jtaguart.h

Thanks
Tobias
