Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278Ab2GZOON (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 10:14:13 -0400
Received: from mail.active-venture.com ([67.228.131.205]:53369 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379Ab2GZOOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 10:14:11 -0400
X-Originating-IP: 108.223.40.66
Date: Thu, 26 Jul 2012 07:14:26 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Johannes Winkelmann <johannes.winkelmann@gmail.com>
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
        Jean Delvare <khali@linux-fr.org>,
        Johannes Winkelmann <johannes.winkelmann@sensirion.com>
Subject: Re: [RFC][PATCH] hwmon: add support for Sensirion C1 sensor
Message-ID: <20120726141426.GA15985@roeck-us.net>
References: <1342789042-13433-1-git-send-email-johannes.winkelmann@sensirion.com>
 <20120721170150.GA13086@roeck-us.net>
 <CAEYbzYsTQttoOnkoYqw9RkDO1zUc3qpyg0CzEY11_=oqdk0H-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEYbzYsTQttoOnkoYqw9RkDO1zUc3qpyg0CzEY11_=oqdk0H-Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Johannes,

On Thu, Jul 26, 2012 at 03:53:12PM +0200, Johannes Winkelmann wrote:
> Hi Guenter,
> 
> Thanks a lot for the feedback; I've incorporated most of it in
> preparation for a v2 of the patch; I have some comments on the points
> I'm not certain about:
> 
[ ... ]
> >> +
> >> +The device communicates with the I2C protocol. All sensors are set to the same
> >> +I2C address 0x70, so an entry with I2C_BOARD_INFO("shtc1", 0x70) can be used
> >> +in the board setup code.
> >> +
> > Please also provide a reference to the other means to instantiate the driver.
> 
> I've checked a couple of documentation files and haven't found what
> else I should add, in fact the other sensor documents I checked didn't
> cover this, except for the one from the sht21 after which I modelled
> the document. Could you give me a pointer where to look?
> 
Just add a reference to Documentation/i2c/instantiating-devices.

Thanks,
Guenter
