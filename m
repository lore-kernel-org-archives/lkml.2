Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042Ab1JCI5D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 04:57:03 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:59083 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852Ab1JCI47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 04:56:59 -0400
Message-ID: <4E8978CB.1000807@atmel.com>
Date: Mon, 03 Oct 2011 10:56:43 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: linux-arm-kernel@lists.infradead.org, alan@linux.intel.com,
        linux-serial@vger.kernel.org, plagnioj@jcrosoft.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] tty/serial: atmel_serial: __devinit_p for probe function
References: <b371e80a96a36d962fb8806c2bd7aa20bb688b88.1317634987.git.nicolas.ferre@atmel.com> <cd489c1d28c26624d6b68399d222aec371045e53.1317634987.git.nicolas.ferre@atmel.com> <20111003085029.GA11710@n2100.arm.linux.org.uk>
In-Reply-To: <20111003085029.GA11710@n2100.arm.linux.org.uk>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2011 10:50 AM, Russell King - ARM Linux :
> On Mon, Oct 03, 2011 at 11:46:16AM +0200, Nicolas Ferre wrote:
>> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>> ---
>>  drivers/tty/serial/atmel_serial.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
>> index a652f8f..453cdb5 100644
>> --- a/drivers/tty/serial/atmel_serial.c
>> +++ b/drivers/tty/serial/atmel_serial.c
>> @@ -1789,7 +1789,7 @@ static int __devexit atmel_serial_remove(struct platform_device *pdev)
>>  }
>>  
>>  static struct platform_driver atmel_serial_driver = {
>> -	.probe		= atmel_serial_probe,
>> +	.probe		= __devexit_p(atmel_serial_probe),
> 
> That doesn't match the patch description (and is probably wrong.)

Yes, indeed.
Sorry for the noise!
-- 
Nicolas Ferre


