Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031Ab2JOPFJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 11:05:09 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:39695 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751603Ab2JOPFG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 11:05:06 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-keystone@list.ti.com - Linux developers for Keystone family of
	devices (May contain non-TIers)" <linux-keystone@list.ti.com>
CC: "Chemparathy, Cyril" <cyril@ti.com>
Subject: RE: [RESET PATCH 2/2] Documentation: of-serial.txt - update for
 clocks phandle for clk
Thread-Topic: [RESET PATCH 2/2] Documentation: of-serial.txt - update for
 clocks phandle for clk
Thread-Index: AQHNquWzZ3YkNUSIEEOohpn9Z3q1lZe6dulw
Date: Mon, 15 Oct 2012 15:05:03 +0000
Message-ID: <3E54258959B69E4282D79E01AB1F32B704201C79@DFLE12.ent.ti.com>
References: <1350313178-3753-1-git-send-email-m-karicheri2@ti.com>
 <1350313178-3753-3-git-send-email-m-karicheri2@ti.com>
In-Reply-To: <1350313178-3753-3-git-send-email-m-karicheri2@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [128.247.5.50]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> -----Original Message-----
>> From: Karicheri, Muralidharan
>> Sent: Monday, October 15, 2012 11:00 AM
>> To: alan@linux.intel.com; gregkh@linuxfoundation.org; linux-serial@vger.kernel.org;
>> linux-kernel@vger.kernel.org; linux-keystone@list.ti.com - Linux developers for Keystone
>> family of devices (May contain non-TIers)
>> Cc: Chemparathy, Cyril; Karicheri, Muralidharan
>> Subject: [RESET PATCH 2/2] Documentation: of-serial.txt - update for clocks phandle for
>> clk
Sorry for the typo, RESET->RESEND. 
>> 
>> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
>> 
>> diff --git a/Documentation/devicetree/bindings/tty/serial/of-serial.txt
>> b/Documentation/devicetree/bindings/tty/serial/of-serial.txt
>> index 0847fde..423b7ff 100644
>> --- a/Documentation/devicetree/bindings/tty/serial/of-serial.txt
>> +++ b/Documentation/devicetree/bindings/tty/serial/of-serial.txt
>> @@ -14,7 +14,10 @@ Required properties:
>>  	- "serial" if the port type is unknown.
>>  - reg : offset and length of the register set for the device.
>>  - interrupts : should contain uart interrupt.
>> -- clock-frequency : the input clock frequency for the UART.
>> +- clock-frequency : the input clock frequency for the UART
>> +	 or
>> +  clocks phandle to refer to the clk used as per Documentation/devicetree
>> +  /bindings/clock/clock-bindings.txt
>> 
>>  Optional properties:
>>  - current-speed : the current active speed of the UART.
>> --
>> 1.7.9.5

