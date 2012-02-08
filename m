Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560Ab2BHKcu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 05:32:50 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48396 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845Ab2BHKcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 05:32:48 -0500
Message-ID: <4F324F4B.3090500@gmail.com>
Date: Wed, 08 Feb 2012 11:32:43 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120129 Thunderbird/10.0
MIME-Version: 1.0
To: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: Alan Cox <alan@linux.intel.com>, Sam Ravnborg <sam@ravnborg.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial: relocate remaining serial drivers from tty/ to
 tty/serial/
References: <1325707287-31038-1-git-send-email-paul.gortmaker@windriver.com> <4F04BFA8.9010100@windriver.com> <20120104220332.GA22985@suse.de> <201201042327.33739.arnd@arndb.de> <20120105054240.GA9093@merkur.ravnborg.org> <20120105124505.73c88f2c@bob.linux.org.uk> <20120105232142.GA10870@windriver.com> <4F324ECB.7040102@gmail.com>
In-Reply-To: <4F324ECB.7040102@gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Damnit! They didn't manage to forward Greg's email. What a crap.

On 02/08/2012 11:30 AM, Jiri Slaby wrote:
> On 01/06/2012 12:21 AM, Paul Gortmaker wrote:
>> --- /dev/null
>> +++ b/drivers/tty/serial/8250/Makefile
>> @@ -0,0 +1,20 @@
>> +#
>> +# Makefile for the 8250 serial device drivers.
>> +#
>> +
>> +obj-$(CONFIG_SERIAL_8250)		+= 8250.o
>> +obj-$(CONFIG_SERIAL_8250_PNP)		+= 8250_pnp.o
>> +obj-$(CONFIG_SERIAL_8250_GSC)		+= 8250_gsc.o
>> +obj-$(CONFIG_SERIAL_8250_PCI)		+= 8250_pci.o
>> +obj-$(CONFIG_SERIAL_8250_HP300)		+= 8250_hp300.o
>> +obj-$(CONFIG_SERIAL_8250_CS)		+= serial_cs.o
>> +obj-$(CONFIG_SERIAL_8250_ACORN)		+= 8250_acorn.o
>> +obj-$(CONFIG_SERIAL_8250_CONSOLE)	+= 8250_early.o
>> +obj-$(CONFIG_SERIAL_8250_FOURPORT)	+= 8250_fourport.o
>> +obj-$(CONFIG_SERIAL_8250_ACCENT)	+= 8250_accent.o
>> +obj-$(CONFIG_SERIAL_8250_BOCA)		+= 8250_boca.o
>> +obj-$(CONFIG_SERIAL_8250_EXAR_ST16C554)	+= 8250_exar_st16c554.o
>> +obj-$(CONFIG_SERIAL_8250_HUB6)		+= 8250_hub6.o
>> +obj-$(CONFIG_SERIAL_8250_MCA)		+= 8250_mca.o
>> +obj-$(CONFIG_SERIAL_8250_FSL)		+= 8250_fsl.o
>> +obj-$(CONFIG_SERIAL_8250_DW)		+= 8250_dw.o
> 
> ...
> 
>> diff --git a/drivers/tty/serial/m32r_sio.c b/drivers/tty/serial/8250/m32r_sio.c
>> similarity index 100%
>> rename from drivers/tty/serial/m32r_sio.c
>> rename to drivers/tty/serial/8250/m32r_sio.c
>> diff --git a/drivers/tty/serial/m32r_sio.h b/drivers/tty/serial/8250/m32r_sio.h
>> similarity index 100%
>> rename from drivers/tty/serial/m32r_sio.h
>> rename to drivers/tty/serial/8250/m32r_sio.h
>> diff --git a/drivers/tty/serial/m32r_sio_reg.h b/drivers/tty/serial/8250/m32r_sio_reg.h
>> similarity index 100%
>> rename from drivers/tty/serial/m32r_sio_reg.h
>> rename to drivers/tty/serial/8250/m32r_sio_reg.h
> 
> Hmm, these cannot be built now :(. Why did you move them?
> 
> It looks like they should be moved back.
> 
> regards,
-- 
js
