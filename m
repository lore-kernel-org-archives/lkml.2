Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932947Ab0HEXHb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 19:07:31 -0400
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:51889 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753672Ab0HEXH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 19:07:27 -0400
Message-ID: <4C5B4404.6010602@euromail.se>
Date: Fri, 06 Aug 2010 01:06:44 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Kevin McNeely <kev@cypress.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        David Brown <davidb@codeaurora.org>,
        Trilok Soni <tsoni@codeaurora.org>,
        Fred <fwk@ubuntu.linuxcertified.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Eric Miao <eric.y.miao@gmail.com>, Ben Dooks <ben-linux@fluff.org>,
        Simtec Linux Team <linux@simtec.co.uk>,
        Todd Fischer <todd.fischer@ridgerun.com>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: cyttsp i2c and spi touchscreen driver init submit
References: <Kevin McNeely <kev@cypress.com> <1281031924-3032-1-git-send-email-kev@cypress.com>
In-Reply-To: <1281031924-3032-1-git-send-email-kev@cypress.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1Oh9WV-0004n0-B7.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1Oh9WV-0004n0-B7 79a1dea24224d4e84e94af5954f68714
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2010 08:12 PM, Kevin McNeely wrote:

> From: Fred <fwk@ubuntu.linuxcertified.com>
> 
> This is a new touchscreen driver for the Cypress Semiconductor
> cyttsp family of devices.  This updated driver is for both the i2c and spi
> versions of the devices. The driver code consists of common core code for
> both i2c and spi driver.  This submission is in response to review comments
> from the initial submission.
> 
> Signed-off-by: Kevin McNeely <kev@cypress.com>
> ---


General impression: There is a lot of useful code in here, but as already
pointed out, well over half of it should not be part of the kernel driver.

Suggestion 1: Clean out the internal state code and use MT protocol B instead.

Suggestion 2: Cut out the single touch calculation, as already pointed out by
Trilok. Why not submit it to the mtdev project instead? The problem is generic
to all new MT drivers, so a common solution while waiting for full MT support in
userspace could be useful.

Thanks,
Henrik
