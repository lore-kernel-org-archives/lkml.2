Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab0CUVQ7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 17:16:59 -0400
Received: from solo.fdn.fr ([80.67.169.19]:55523 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752739Ab0CUVQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 17:16:57 -0400
Date: Sun, 21 Mar 2010 22:16:53 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Alexey Dobriyan <adobriyan@gmail.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk, mgarski@post.pl, linux-input@vger.kernel.org,
       Vojtech Pavlik <vojtech@suse.cz>, Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH] Route kbd LEDs through the generic LEDs layer (5th version)
Message-ID: <20100321211653.GS12469@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Pavel Machek <pavel@ucw.cz>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
	mgarski@post.pl, linux-input@vger.kernel.org,
	Vojtech Pavlik <vojtech@suse.cz>,
	Richard Purdie <rpurdie@rpsys.net>
References: <20100307200250.GA9340@const.famille.thibault.fr> <20100310133004.GM5127@const.bordeaux.inria.fr> <20100321210938.GB2057@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100321210938.GB2057@elf.ucw.cz>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek, le Sun 21 Mar 2010 22:09:38 +0100, a écrit :
> Now, minor comments:
> 
> sometimes it uses "numl" (led name), sometimes it uses "numlock"
> trigger name.

Yes, I preferred to stick to the existing names: numl like LED_NUML, and
numlock like VC_NUMLOCK.  I don't have any opinion on this however.

> root@amd:/sys/class/leds/input5::numl# echo heartbeat > trigger
> 
> did not do the trick on my thinkpad. It still acts as numlock led. Is
> it driven by hw? input5::capsl works as expected.

If it is a laptop, it is likely, depending on the BIOS & such.
On my laptop, doing this works fine.

Samuel
