Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757828Ab3AIMCU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 07:02:20 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:57047 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757619Ab3AIMCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 07:02:17 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH 2/3] ARM: ux500: Turn on the 'heartbeat' LED trigger
Date: Wed, 9 Jan 2013 12:02:13 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: Lee Jones <lee.jones@linaro.org>, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linus.walleij@stericsson.com
References: <1357725965-27342-1-git-send-email-lee.jones@linaro.org> <201301091156.55644.arnd@arndb.de> <20130109115911.GI3931@n2100.arm.linux.org.uk>
In-Reply-To: <20130109115911.GI3931@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201301091202.14105.arnd@arndb.de>
X-Provags-ID: V02:K0:/w+VV96h1WkPKWcfLjnGw+TGGM0p/j5KMsOkCp7GvA/
 3v8FF+yYO18OF1IFHqu8HUNlclwwf7XFb046LgAeu0seuLQqrc
 Dz+bEuIZESx6cuEx5YGXPeV3uxMNLWyHiukGsYGBta9fkfhbZg
 /k5sq0cSE+CVaPJAxUHbFZVtATEX7psHT6yEbAuUquQwk+vG5W
 p6TW5SPGdqzJRJWzIFyv68qby8L9Rly+9/RZPdsLCGA8y2eafj
 jPmPsILVOl9hNoPPRPZrKeH8pRkJ45glnpn1+6KI8PcN8BBoqw
 WURTD4RnagqJCA7QUGySgCGmYtDVYPHcT6k95H9fS6GQWloPzm
 r/Wuiq23OIWWGrqrNkHM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 January 2013, Russell King - ARM Linux wrote:
> On Wed, Jan 09, 2013 at 11:56:55AM +0000, Arnd Bergmann wrote:

> > Right. The change I suggested fixes the build errors but doesn't actually
> > make the intended behavior correct. Just using a configuration file is the
> > right solution here.
> 
> Hang on a moment: if the lack of the LEDs support leads to build errors,
> doesn't that mean there's missing conditional compilation?

The build error would have come only from selecting LEDS_TRIGGERS without
also selecting NEW_LEDS and LEDS_CLASS. I haven't actually tried if that
results in a hard error, but you'd get at least a Kconfig warning.

	Arnd
