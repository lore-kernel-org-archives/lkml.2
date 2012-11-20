Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414Ab2KTJnz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 04:43:55 -0500
Received: from smtp1.goneo.de ([212.90.139.80]:52111 "EHLO smtp1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751582Ab2KTJnx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 04:43:53 -0500
X-Spam-Flag: NO
X-Spam-Score: -2.646
From: Lars Poeschel <poeschel@lemonage.de>
To: Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [PATCH v3 2/5] mfd: add viperboard driver
Date: Tue, 20 Nov 2012 10:44:20 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0-4-amd64; KDE/4.8.4; x86_64; ; )
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Lars Poeschel <larsi@wh2.tu-dresden.de>, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, jic23@cam.ac.uk, khali@linux-fr.org,
        ben-linux@fluff.org, grant.likely@secretlab.ca,
        linux-iio@vger.kernel.org
References: <1352126906-4560-1-git-send-email-larsi@wh2.tu-dresden.de> <20121119173036.GE18738@sortiz-mobl> <20121120083456.GA14722@pengutronix.de>
In-Reply-To: <20121120083456.GA14722@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <201211201044.20970.poeschel@lemonage.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 November 2012 at 09:34:56, Wolfram Sang wrote:
> I'll try to have a look this week. It fell a bit off because linux-i2c
> was not in CC. I do wonder about the naming, though. VIPERBOARD is
> probably the board name, but not the IP core/SoC name?

I am sorry, that I forgot the CC.
You are right it is the board name but not a IP/SoC name. It seems this 
device is weird to kernel developers - you are not the first one asking. You 
don't have to see the term board as in kernel sense where it describes a 
specific SoC and the components connected to it. It is a circuit board, that 
connects to usb on one side and GPIO, I²C and so on on the other side. You 
can have a look at it here:
http://nanorivertech.com/viperboard-specs.html
