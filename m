Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057Ab1JCJtm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 05:49:42 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:63182 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503Ab1JCJtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 05:49:32 -0400
Message-ID: <4E898517.6020104@atmel.com>
Date: Mon, 03 Oct 2011 11:49:11 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arm-kernel@lists.infradead.org, alan@linux.intel.com,
        linux-serial@vger.kernel.org, plagnioj@jcrosoft.com,
        linux-kernel@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH 3/3] tty/serial: atmel_serial: __devinit_p for probe function
References: <cd489c1d28c26624d6b68399d222aec371045e53.1317634987.git.nicolas.ferre@atmel.com> <d7c2023edfbeb3d21bccd5b997f7806874b01b04.1317636473.git.nicolas.ferre@atmel.com> <4355360.0xR5ZY7sEk@wuerfel>
In-Reply-To: <4355360.0xR5ZY7sEk@wuerfel>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2011 11:36 AM, Arnd Bergmann :
> On Monday 03 October 2011 12:11:19 Nicolas Ferre wrote:
>>  }
>>  
>>  static struct platform_driver atmel_serial_driver = {
>> -       .probe          = atmel_serial_probe,
>> +       .probe          = __devinit_p(atmel_serial_probe),
>>         .remove         = __devexit_p(atmel_serial_remove),
>>         .suspend        = atmel_serial_suspend,
>>         .resume         = atmel_serial_resume,
> 
> Still wrong: __devinit_p does not exist and is not needed.

OMG, the not-enouth-coffee syndrome... twice!

So we forget all this and I try to increase my signal/noise ratio ;-)

Bye,
-- 
Nicolas Ferre
