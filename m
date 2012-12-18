Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477Ab2LRGvP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 01:51:15 -0500
Received: from ngcobalt02.manitu.net ([217.11.48.102]:46179 "EHLO
	ngcobalt02.manitu.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233Ab2LRGvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 01:51:14 -0500
X-manitu-Original-Sender-IP: 79.230.55.182
X-manitu-Original-Receiver-Name: ngcobalt02.manitu.net
Message-ID: <50D01256.1020105@grandegger.com>
Date: Tue, 18 Dec 2012 07:51:02 +0100
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Roland Stigge <stigge@antcom.de>
CC: rmallon@gmail.com, gregkh@linuxfoundation.org, linus.walleij@linaro.org,
        broonie@opensource.wolfsonmicro.com, w.sang@pengutronix.de,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        daniel-gl@gmx.net, sr@denx.de, plagnioj@jcrosoft.com,
        linux-arm-kernel@lists.infradead.org, highguy@gmail.com
Subject: Re: [PATCH RESEND 0/6 v10] gpio: Add block GPIO
References: <1355495185-24220-1-git-send-email-stigge@antcom.de> <50CB68AB.5070806@grandegger.com> <50CBBB25.20002@antcom.de> <50CF03FB.2030100@grandegger.com> <50CF0744.7040404@grandegger.com> <50CF1EF1.2070601@antcom.de> <50CF237E.5020409@antcom.de> <50CF4838.9000401@grandegger.com> <50CF5327.6070205@antcom.de> <50CF584E.1040601@grandegger.com> <50CF5E45.5030104@antcom.de> <50CF76D3.9030708@grandegger.com> <50CF8FA9.8050609@antcom.de>
In-Reply-To: <50CF8FA9.8050609@antcom.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2012 10:33 PM, Roland Stigge wrote:
> On 17/12/12 20:47, Wolfgang Grandegger wrote:
>> On 12/17/2012 07:02 PM, Roland Stigge wrote:
>>> On 12/17/2012 06:37 PM, Wolfgang Grandegger wrote:
>>>> 	/* Do synchronous data output with a single write access */
>>>> 	__raw_writel(~mask, pio + PIO_OWDR);
>>>> 	__raw_writel(mask, pio + PIO_OWER);
>>>> 	__raw_writel(val, pio + PIO_ODSR);
>>>>
>>>> For caching we would need a storage. Not sure if it's worth compared to
>>>> a context switch into the kernel.
>>>
>>> Block GPIO is not only for you in userspace. ;-) You can also implement
>>> efficient n-bit bus I/O in kernel drivers, n-bit-banging. :-) So not
>>> always context switches involved.
>>
>> OK, what do you think about the following untested patch:
> 
> Looks good!
> 
> Why "untested"? ;-)

Because I didn't have a chance to test it yet. Will do tomorrow.

Wolfgang.

