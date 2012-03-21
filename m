Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181Ab2CUGPg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 02:15:36 -0400
Received: from smtprelay05.ispgateway.de ([80.67.31.99]:38303 "EHLO
	smtprelay05.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913Ab2CUGPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 02:15:34 -0400
Message-ID: <4F697201.1090206@bwalle.de>
Date: Wed, 21 Mar 2012 07:15:29 +0100
From: Bernhard Walle <bernhard@bwalle.de>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:11.0) Gecko/20120313 Thunderbird/11.0
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel,gmane.linux.ports.arm.omap
To: Arnd Bergmann <arnd@arndb.de>
CC: Bernhard Walle <walle@corscience.de>, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH] mfd: Add TWL4030 PWM driver
References: <1332262083-9375-1-git-send-email-walle@corscience.de> <201203202202.12060.arnd@arndb.de>
In-Reply-To: <201203202202.12060.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Df-Sender: YmVybmhhcmRAYndhbGxlLmRl
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 20.03.12 23:02, schrieb Arnd Bergmann:
> On Tuesday 20 March 2012, Bernhard Walle wrote:
>>
>> This PWM driver uses the PWM of the TWL4030. The driver for the TWL6030
>> PWM has been used as mode, but the PWM registers are different.
>>
>> The driver can be used and has been tested in conjunction with
>> pwm-backlight to control a backlight LED of a LCD touch screen.
>>
>> Signed-off-by: Bernhard Walle <walle@corscience.de>
> 
> Since it's too late for v3.4 now and we will get a new pwm
> subsystem in v3.5, I suggest you change the driver to work
> register with that subsystem instead of just using the old
> header file. Note that drivers/mfd is not really the right
> place anyway, because this is not a multifunction driver but
> just one device driver that happens to be a slave of an mfd.

Does that new subsystem already exist in some tree?

Regards,
Bernhard
