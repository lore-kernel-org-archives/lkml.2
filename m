Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933788Ab2LGMQh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 07:16:37 -0500
Received: from antcom.de ([188.40.178.216]:51902 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933774Ab2LGMQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 07:16:35 -0500
Message-ID: <50C1DE21.8050709@antcom.de>
Date: Fri, 07 Dec 2012 13:16:33 +0100
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.11) Gecko/20121123 Icedove/10.0.11
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: gregkh@linuxfoundation.org, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, w.sang@pengutronix.de,
        jbe@pengutronix.de, plagnioj@jcrosoft.com, highguy@gmail.com,
        broonie@opensource.wolfsonmicro.com, daniel-gl@gmx.net,
        rmallon@gmail.com, tru@work-microwave.de, sr@denx.de,
        wg@grandegger.com
Subject: Re: [PATCH 0/6 v10] gpio: Add block GPIO
References: <1354830456-17590-1-git-send-email-stigge@antcom.de> <20121207103643.34ca6dc5@pyramind.ukuu.org.uk> <50C1DBD4.1040007@antcom.de>
In-Reply-To: <50C1DBD4.1040007@antcom.de>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2012 01:06 PM, Roland Stigge wrote:
> On 12/07/2012 11:36 AM, Alan Cox wrote:
>>> * Device interface for userland access (alternative to sysfs)
>>
>> Currently we can set different permissions on different GPIO lines. Your
>> driver change drives a truck through this facility.

What I maybe misread in your concern: The dev interface is actually an
"alternative to sysfs for block GPIO", not considered as a replacement
for the current sysfs interface for _single_ GPIOs.

The fate of the latter one can be discussed separately.

Also, the sysfs interface for block GPIO can be left out of my patch
series, if necessary.

Roland
