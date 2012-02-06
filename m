Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589Ab2BFK7L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 05:59:11 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:32900 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751979Ab2BFK7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 05:59:09 -0500
MIME-Version: 1.0
In-Reply-To: <1328102793-4313-1-git-send-email-s.hauer@pengutronix.de>
References: <1328102793-4313-1-git-send-email-s.hauer@pengutronix.de>
From: Christian Gmeiner <christian.gmeiner@gmail.com>
Date: Mon, 6 Feb 2012 11:58:48 +0100
Message-ID: <CAH9NwWfWVeOaNH6KRXK==sbLb3kR2eJz2+c9+k7zyAFgzwF+Vw@mail.gmail.com>
Subject: Re: [RESEND] Congatec CGEB base, i2c and watchdog driver support
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Jean Delvare <khali@linux-fr.org>, linux-i2c@vger.kernel.org,
        linux-watchdog@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        kernel@pengutronix.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sascha,

2012/2/1 Sascha Hauer <s.hauer@pengutronix.de>:
> This is a resend of the series I posted in january, only difference
> is that this time I have included the i2c and watchdog lists. To
> minimize dependencies I suggest pushing this via the mfd tree, given
> I get acks on the I2C and watchdog part.
>
> The following series adds support for the Congatec CGEB interface
> found on some Congatec x86 boards. The CGEB interface is a BIOS
> interface which provides access to onboard peripherals like I2C
> busses and watchdogs. It works by mapping BIOS code and searching
> for magic values which specify the entry points to the CGEB call.
> The CGEB call is an API provided by the BIOS which provides access
> to the functions in an ioctl like fashion.
>
> For more information about the CGEB API have a look at:
>
> http://www.congatec.com/single_news+M5d58c9cd155.html
>
> This document only describes the C API, unfortunately not the
> underlying BIOS interface.
>
> Comments very appreciated.
>

I am looking forward to see your work in mainline soon. I have here
some boards from
Congatec and I will review and test your patches during this week.


Greets
--
Christian Gmeiner, MSc
