Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758115Ab1EZPdM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 11:33:12 -0400
Received: from host-85-30-130-173.sydskane.nu ([85.30.130.173]:34347 "EHLO
	oden.holstenhof.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757853Ab1EZPdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 11:33:08 -0400
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 May 2011 11:33:08 EDT
Message-ID: <f89af2756c3530c8b7c58a83885e5811.squirrel@oden.holstenhof.se>
Date: Thu, 26 May 2011 17:26:24 +0200 (CEST)
Subject: Question about MFD devices.
From: "Joachim Holst" <jocke@holstenhof.se>
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.15
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi List!

Sorry to bother you with a somewhat stupid newbie question, but I've
already tried this one on the "kernel-newbies" list without a reply :-(

I'm trying to do a simple driver on an embedded (ARM) system that needs to
access some functionality in an MFD device. I've deducted that my driver
needs to be integrated into the MFD device structure, otherwise I won't
really be able to access the required functions.

In the process, I've been trying to figure out when these MFD devices are
supposed to be used, but I don't see the logic behind them as of yet.
Currently it seems to me that "if a chip has more than one function, it's
an MFD" no matter what type of functions the chip supplies.

To me, MFD seems to somewhat duplicate the standard kernel driver
structure, most implementations I've seen make it rather difficult to use
exported interfaces without integrating your driver into the structure.

Personally, I really don't think that a simple driver that toggles a GPIO
X times based on an ADC value should be integrated into an MFD device
structure. A misc device seems a bit more appropriate for this.

I guess that my conclusion are way wrong, so I hope that someone on the
list can enlighten me about this.

BRs,
/Jocke!



-- 
If it can't be fixed with duct-tape, it's definitely borken...

