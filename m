Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415Ab1DEGh7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 02:37:59 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:53203 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab1DEGh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 02:37:58 -0400
Message-ID: <34890DB1679E41119ADB156E2CFEC4C9@subhasishg>
From: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
To: "Arnd Bergmann" <arnd@arndb.de>
Cc: <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <sachi@mistralsolutions.com>, "Samuel Ortiz" <sameo@linux.intel.com>,
        <nsekhar@ti.com>, "open list" <linux-kernel@vger.kernel.org>,
        <m-watkins@ti.com>, "Marc Kleine-Budde" <mkl@pengutronix.de>,
        "Stalin Srinivasan" <stalin.s@mistralsolutions.com>
References: <1299592667-21367-1-git-send-email-subhasish@mistralsolutions.com> <201103111628.57549.arnd@arndb.de> <17BF3847C06240EC921FB684D3120DEC@subhasishg> <201103301259.28483.arnd@arndb.de>
In-Reply-To: <201103301259.28483.arnd@arndb.de>
Subject: Re: [PATCH v3 1/7] mfd: add pruss mfd driver.
Date: Tue, 5 Apr 2011 12:10:46 +0530
Organization: Mistral Solutions
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
Importance: Normal
X-Mailer: Microsoft Windows Live Mail 14.0.8117.416
X-MimeOLE: Produced By Microsoft MimeOLE V14.0.8117.416
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Wednesday 30 March 2011, Subhasish Ghosh wrote:
>>
>> >> +s32 pruss_disable(struct device *dev, u8 pruss_num)
>> >> +{
>> >> + struct da8xx_pruss *pruss = dev_get_drvdata(dev->parent);
>> >> + struct da8xx_prusscore_regs *h_pruss;
>> >> + struct pruss_map *pruss_mmap = (struct pruss_map *)pruss->ioaddr;
>> >> + u32 temp_reg;
>> >> + u32 delay_cnt;
>> >
>> > Can you explain the significance of pruss_num? As far as I
>> > can tell, you always pass constants in here, so it should
>> > be possible to determine the number from the device.
>>
>> SG - The number is not programmed in the device, I need something to 
>> decide
>> which PRU to disable or enable.
>
> I still don't understand. Please explain how the devices
> relate to the multiple PRUs in hardware.

There are two devices, CAN and UART, in our case we use the PRU as follows:
1. CAN-TX on PRU0, CAN-RX on PRU1
2. SUART-TX on PRU0, SUART-RX on PRU1
3. SUART-TXRX on PRU0, SUART-TXRX on PRU1


 

