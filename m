Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751593Ab0IVIBn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 04:01:43 -0400
Received: from relay03-haj2.antispameurope.com ([83.246.65.53]:49207 "EHLO
	relay03-haj2.antispameurope.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751187Ab0IVIBl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 04:01:41 -0400
Message-ID: <4C99B7E3.4070501@iis.fraunhofer.de>
Date: Wed, 22 Sep 2010 10:01:39 +0200
From: Manuel Stahl <manuel.stahl@iis.fraunhofer.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH] Add sc16is7x2 driver
References: <4C80F419.5070601@iis.fraunhofer.de> <20100913172544.a81e8422.akpm@linux-foundation.org> <4C8F7381.50300@iis.fraunhofer.de> <20100921204238.GE25112@kroah.com>
In-Reply-To: <20100921204238.GE25112@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
X-MIME-Autoconverted: from 8bit to quoted-printable by iis.fhg.de id KAA12622
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 21.09.2010 22:42, schrieb Greg KH:
> On Tue, Sep 14, 2010 at 03:07:13PM +0200, Manuel Stahl wrote:
>> --- a/include/linux/serial_core.h
>> +++ b/include/linux/serial_core.h
>> @@ -47,6 +47,9 @@
>>   #define PORT_U6_16550A	19	/* ST-Ericsson U6xxx internal UART */
>>   #define PORT_MAX_8250	19	/* max port ID */
>>
>> +/* SC16IS7x2 SPI UART */
>> +#define PORT_SC16IS7X2	19
>
> Hm, didn't you just duplicate the number here?  Shouldn't that be "20"
> and you bump the max up?

Oh, that might be true.

> In the end, we need to just drop those, I don't think we need defines
> anymore, but I need to look at it some more to find out.

Thank you for doing that, Greg.

Regards,
-- 
Dipl.-Inf. Manuel Stahl
Fraunhofer-Institut für Integrierte Schaltungen IIS
- Leistungsoptimierte Systeme -
Nordostpark 93                Telefon  +49 (0)911/58061-6419
90411 Nürnberg                Fax      +49 (0)911/58061-6398
http://www.iis.fraunhofer.de  manuel.stahl@iis.fraunhofer.de
