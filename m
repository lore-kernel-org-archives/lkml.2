Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754335Ab2JOSPt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 14:15:49 -0400
Received: from antcom.de ([188.40.178.216]:48070 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465Ab2JOSPs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 14:15:48 -0400
Message-ID: <507C52D1.4050104@antcom.de>
Date: Mon, 15 Oct 2012 20:15:45 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, w.sang@pengutronix.de,
        jbe@pengutronix.de, highguy@gmail.com,
        broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH RFC 2/6 v3] gpio: Add sysfs support to block GPIO API
References: <1350069085-13283-1-git-send-email-stigge@antcom.de> <1350069085-13283-3-git-send-email-stigge@antcom.de> <20121015180702.GA12801@game.jcrosoft.org>
In-Reply-To: <20121015180702.GA12801@game.jcrosoft.org>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2012 08:07 PM, Jean-Christophe PLAGNIOL-VILLARD wrote:
> On 21:11 Fri 12 Oct     , Roland Stigge wrote:
>> This patch adds sysfs support to the block GPIO API.
>>
>> Signed-off-by: Roland Stigge <stigge@antcom.de>
>>
>> ---
>>  Documentation/ABI/testing/sysfs-gpio |    6 
>>  drivers/gpio/gpiolib.c               |  226 ++++++++++++++++++++++++++++++++++-
>>  include/asm-generic/gpio.h           |   11 +
>>  include/linux/gpio.h                 |   13 ++
>>  4 files changed, 254 insertions(+), 2 deletions(-)
> I really don't like this sysfs we need to add a specific device with ioctl

The good thing about the current style is that you have a single value
for the whole block in a single file just as for single GPIOs. You can
consider it as a generalized GPIO.

And I like it. :-)

Thanks for considering,

Roland
