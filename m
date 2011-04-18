Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809Ab1DRI30 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 04:29:26 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:6786 "EHLO sjogate2.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753558Ab1DRI3W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 04:29:22 -0400
Message-ID: <4DABF65C.5070607@atmel.com>
Date: Mon, 18 Apr 2011 10:29:16 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.2.13) Gecko/20110303 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: "Voss, Nikolaus" <N.Voss@weinmann.de>
CC: "'Linux Kernel'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/spi/atmel_spi.c: prevent premature irqs
References: <EF2E73589CA71846A15D0B2CDF79505D086F931361@wm021.weinmann.com> <4DA2C0C0.6050903@atmel.com> <EF2E73589CA71846A15D0B2CDF79505D086F9314A4@wm021.weinmann.com>
In-Reply-To: <EF2E73589CA71846A15D0B2CDF79505D086F9314A4@wm021.weinmann.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 11/04/2011 11:38, Voss, Nikolaus :
> Hi,
> 
>> What about something like this?
>>
>> /* disable all interrupts to avoid premature irq triggering */
>> spi_writel(as, IDR, 0xffffffff);
> 
> I implemented it this way the first time, but on a second approach I used
> the more specific variant.
> 
> That way it is kept symmetric to the irq enable part in the transfer method
> which enables no more than the irqs disabled in my patch. And I generally
> feel better when not writing live values to don't care bits ;-).

That makes sense. I add my ACK.

Bye,
-- 
Nicolas Ferre

