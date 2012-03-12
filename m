Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757541Ab2CLVwx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 17:52:53 -0400
Received: from antcom.de ([188.40.178.216]:38282 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757486Ab2CLVwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 17:52:51 -0400
Message-ID: <4F5E702F.8040703@antcom.de>
Date: Mon, 12 Mar 2012 22:52:47 +0100
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM Open Source Research and Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20120216 Icedove/8.0
MIME-Version: 1.0
To: Wolfram Sang <w.sang@pengutronix.de>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        linux-arm-kernel@lists.infradead.org, arnd@arndb.de
Subject: Re: [PATCH v7 0/4] USB: OHCI-HCD: Support for LPC32xx
References: <1331463219-23293-1-git-send-email-stigge@antcom.de> <20120312190241.GA28087@pengutronix.de>
In-Reply-To: <20120312190241.GA28087@pengutronix.de>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram,

On 12/03/12 20:02, Wolfram Sang wrote:
> On Sun, Mar 11, 2012 at 11:53:35AM +0100, Roland Stigge wrote:
>> These patches add support for the LPC32xx to the ohci-pnx4008
>> driver and make the driver use smbus functions.
> 
> Do you have a branch ready to test (USB driver fixes + mach
> additions)? I'd like to test but I get lots of conflicts when
> adding the mach related stuff. I probably have a different base?

I just pushed into the following branches at
git://git.antcom.de/linux-2.6.git :

* lpc32xx/usb - The ohci-pnx driver as submitted on the USB mailing list
* lpc32xx/eth - The ethernet driver as submitted on the ethernet
                mailing list
* lpc32xx/baseline - Patches on top of v3.3-rc7 which have already been
                     accepted into the various subsystem maintainer's
                     repos. This is the baseline on top of which the
                     next two branches are forked from
* lpc32xx/mach-lpc32xx-usb - Mach specific USB part
* lpc32xx/mach-lpc32xx-eth - Mach specific ethernet part

Roland
