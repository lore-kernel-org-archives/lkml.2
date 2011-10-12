Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770Ab1JLMD1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 08:03:27 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:33377 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858Ab1JLMDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 08:03:25 -0400
Message-ID: <4E9581DE.20702@atmel.com>
Date: Wed, 12 Oct 2011 14:02:38 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        claudio@evidence.eu.com, jesper.nilsson@axis.com,
        alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [RFC PATCH] tty/serial: RS485 bindings for device tree
References: <1318353208-24422-1-git-send-email-nicolas.ferre@atmel.com> <4E947CA6.9010703@atmel.com> <3289709.mzRgbAUyPT@wuerfel>
In-Reply-To: <3289709.mzRgbAUyPT@wuerfel>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2011 08:41 PM, Arnd Bergmann :
> On Tuesday 11 October 2011 19:28:06 Nicolas Ferre wrote:
>>
>>> +Optional properties:
>>> +- linux,rs485-enabled-at-boot-time: empty property telling to enable the rs485
>>> +  feature at boot time. It can be disabled later with proper ioctl.
>>
>> +- linux,rs485-rx-during-tx: empty property that enable the receiving of data
>> +  even whilst sending data.
> 
> This does not sound too linux specific. If it's a hardware property, don't
> use the 'linux,' prefix and just make it 'rs484-full-duplex' or such.

Ok, I understand. Your remark may also apply to linux,rs485-rts-delay.
So we may end-up with:

- linux,rs485-enabled-at-boot-time
- rs485-rx-during-tx
- rs485-rts-delay

Best regards,
-- 
Nicolas Ferre
