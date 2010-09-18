Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324Ab0IROGW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 10:06:22 -0400
Received: from infernal.debian.net ([87.230.26.131]:47848 "EHLO
	infernal.debian.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754592Ab0IROGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 10:06:20 -0400
X-Greylist: delayed 1805 seconds by postgrey-1.27 at vger.kernel.org; Sat, 18 Sep 2010 10:06:20 EDT
Date: Sat, 18 Sep 2010 15:36:11 +0200
From: Andreas Bombe <aeb@debian.org>
To: Alex Riesen <raa.lkml@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Arnd Bergmann <arnd@arndb.de>,
        linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: OOPS in hiddev_open on connecting "Logitech MX620 Laser
 Cordless Mouse"
Message-ID: <20100918133610.GA4554@amos.infernal>
References: <AANLkTikOowB=8=3cnJ0QgJNfBsVeMUrkNT0E0uH2LDXL@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikOowB=8=3cnJ0QgJNfBsVeMUrkNT0E0uH2LDXL@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 18, 2010 at 11:30:56AM +0200, Alex Riesen wrote:
> Happens with Linus' master at 509344b8b4d365b7ff3bce97198d83a57b7c3f31
> The tree is modified, but I doubt the patches I have can cause this. I attach
> then anyway. They never caused a conflict, so just the patches (in case of doubt
> I can push the tree somewhere).

I can confirm the same Oops on an unpatched kernel from Linus' git
(v2.6.36-rc4-134-g03a7ab0). I have a Logitech G500 mouse.

> The oops is reproducable. lsusb hangs (D state) after the oops.

However on my machine lsusb doesn't hang.
