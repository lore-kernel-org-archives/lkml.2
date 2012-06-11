Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459Ab2FKMb6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 08:31:58 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51711 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754285Ab2FKMb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 08:31:57 -0400
Message-ID: <4FD5E538.4050601@gmail.com>
Date: Mon, 11 Jun 2012 07:31:52 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Wolfram Sang <w.sang@pengutronix.de>
CC: devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] devicetree: bindings: gpio-i2c belongs to i2c not gpio
References: <1334934487-19201-1-git-send-email-w.sang@pengutronix.de> <20120611122648.GA4407@pengutronix.de>
In-Reply-To: <20120611122648.GA4407@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2012 07:26 AM, Wolfram Sang wrote:
> On Fri, Apr 20, 2012 at 05:08:02PM +0200, Wolfram Sang wrote:
>> gpio-i2c describes an I2C controller (using gpios for data and clock),
>> so it must be described in i2c, not gpio.
>>
>> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
>> ---
>>  .../{gpio/gpio_i2c.txt => i2c/gpio-i2c.txt}        |    0
>>  1 file changed, 0 insertions(+), 0 deletions(-)
>>  rename Documentation/devicetree/bindings/{gpio/gpio_i2c.txt => i2c/gpio-i2c.txt} (100%)
>>
>> diff --git a/Documentation/devicetree/bindings/gpio/gpio_i2c.txt b/Documentation/devicetree/bindings/i2c/gpio-i2c.txt
>> similarity index 100%
>> rename from Documentation/devicetree/bindings/gpio/gpio_i2c.txt
>> rename to Documentation/devicetree/bindings/i2c/gpio-i2c.txt
> 
> Any objections to me taking the patch via the i2c-tree?

That's fine.

Acked-by: Rob Herring <rob.herring@calxeda.com>
