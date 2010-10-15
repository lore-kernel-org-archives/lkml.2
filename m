Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079Ab0JOHYm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 03:24:42 -0400
Received: from relay03-haj2.antispameurope.com ([83.246.65.53]:32818 "EHLO
	relay03-haj2.antispameurope.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754011Ab0JOHYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 03:24:41 -0400
Message-ID: <4CB801B2.808@iis.fraunhofer.de>
Date: Fri, 15 Oct 2010 09:24:34 +0200
From: Manuel Stahl <manuel.stahl@iis.fraunhofer.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
CC: linux-serial@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH resend] Add sc16is7x2 driver
References: <4CAD818B.2070603@iis.fraunhofer.de> <20101014190133.GB1009@kroah.com>
In-Reply-To: <20101014190133.GB1009@kroah.com>
Content-Type: multipart/mixed;
 boundary="------------090604090007020909070205"
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090604090007020909070205
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by iis.fhg.de id JAA28550

On 14.10.2010 21:01, Greg KH wrote:
> On Thu, Oct 07, 2010 at 10:15:07AM +0200, Manuel Stahl wrote:
>> --- /dev/null
>> +++ b/include/linux/spi/sc16is7x2.h
>> @@ -0,0 +1,17 @@
>> +#ifndef LINUX_SPI_SC16IS752_H
>> +#define LINUX_SPI_SC16IS752_H
>> +
>> +#define SC16IS7X2_NR_GPIOS 8
>> +
>> +struct sc16is7x2_platform_data {
>> +	unsigned int	uartclk;
>> +	/* uart line number of the first channel */
>> +	unsigned	uart_base;
>> +	/* number assigned to the first GPIO */
>> +	unsigned	gpio_base;
>> +	char		*label;
>> +	/* list of GPIO names (array length =3D SC16IS7X2_NR_GPIOS) */
>> +	const char	*const *names;
>> +};
>> +
>> +#endif
>
> Why is this needed in a .h file?  What other .c file uses this define
> and structure?
>
> thanks,
>
> greg k-h

The board setup code can pass information about the uart and gpio=20
enumeration. It can also define names for the GPIOs. Futhermore the base=20
clock of the chip must be known, as it can be clocked by an external devi=
ce.

Regards,
--=20
Manuel Stahl
Fraunhofer-Institut IIS
Leistungsoptimierte Systeme

Nordostpark 93
D90411 N=FCrnberg
Telefon  +49 (0)911/58061-6419
Fax      +49 (0)911/58061-6398
E-Mail   manuel.stahl@iis.fraunhofer.de

http://www.iis.fraunhofer.de
http://www.smart-power.fraunhofer.de

--------------090604090007020909070205
Content-Type: text/x-vcard; charset=utf-8;
 name="manuel_stahl.vcf"
Content-Disposition: attachment;
 filename="manuel_stahl.vcf"
Content-Transfer-Encoding: 7bit

begin:vcard
fn:Manuel Stahl
n:Stahl;Manuel
email;internet:manuel.stahl@iis.fraunhofer.de
tel;work:+49 911 58061-6419
x-mozilla-html:FALSE
version:2.1
end:vcard


--------------090604090007020909070205--
