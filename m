Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136Ab1EHBpk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 21:45:40 -0400
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:32927 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753746Ab1EHBpU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 21:45:20 -0400
Subject: Re: [PATCH][WAS:bcmai,axi] bcma: add Broadcom specific AMBA bus
 driver
From: Michael =?ISO-8859-1?Q?B=FCsch?= <m@bues.ch>
To: George Kashperko <george@znau.edu.ua>
Cc: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        b43-dev@lists.infradead.org, Greg KH <greg@kroah.com>,
        Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Arend van Spriel <arend@broadcom.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <rmk@arm.linux.org.uk>,
        Andy Botting <andy@andybotting.com>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1304796956.13983.65.camel@dev.znau.edu.ua>
References: <1304632783-8781-1-git-send-email-zajec5@gmail.com>
	 <201105061605.31625.arnd@arndb.de>
	 <BANLkTikjr0ZTNOu69F+iKhwufE9KKMg4Tg@mail.gmail.com>
	 <BANLkTimGBNT4FkS4mO9ToLWft0bCEYcEgg@mail.gmail.com>
	 <1304790665.13983.10.camel@dev.znau.edu.ua>
	 <BANLkTikLFff_86Fvg+jSty9vGLENiELF2Q@mail.gmail.com>
	 <1304792795.13983.28.camel@dev.znau.edu.ua>
	 <BANLkTi=6BFD4OmtU1WPxjbFJQe36=mZKEA@mail.gmail.com>
	 <1304794931.13983.44.camel@dev.znau.edu.ua>
	 <BANLkTik9FWgzpNWuMXXRjOj-rDvPNY_nCA@mail.gmail.com>
	 <1304796956.13983.65.camel@dev.znau.edu.ua>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 08 May 2011 03:44:41 +0200
Message-ID: <1304819081.21680.6.camel@maggie>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-05-07 at 22:35 +0300, George Kashperko wrote: 
> dbg_bcma_device_name
> {
> #ifdef DEBUG
> 		case/switch/if/else stuff
> #endif
> 		return NULL;
> }
> But I don't see here much sense to hardcode names other than those of
> buscommons/buscores for debugging purposes.

Would you please read and understand the code before discussing this?
That would help the discussion on the technical side.

Those names are hardcoded by definition. And just like 14e4 is the PCI
ID for Broadcom devices, 800 is the AXI ID for Broadcom Chipcommon.

And building an #ifdef mess around this stuff is not better than having
a few bytes of _helpful_ information messages.
You are absolutely right that those messages only help 1% of the people.
Just as _any_ other kernel message.

-- 
Greetings Michael.

