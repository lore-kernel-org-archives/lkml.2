Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346Ab2GBAuH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 20:50:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55346 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468Ab2GBAuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 20:50:05 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sun, 1 Jul 2012 18:49:45 -0600
X-Google-Sender-Auth: sjNPanLmzPzw8t1TS6NjYSYgZ5A
Message-ID: <CACxGe6tyO5u7eiq1OiPX-u439YAcQDFz3eOOGZ4bNPtwmYwNkg@mail.gmail.com>
Subject: SPI, GPIO, and DT maintainer ship (cry for help)
To: Robert Herring <rob.herring@calxeda.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <w.sang@pengutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        spi-devel-general-request@lists.sourceforge.net,
        devicetree-discuss <devicetree-discuss@ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram, Rob & Linus W.

I believe all three of you know that I'm in the process of moving to
Scotland. The house is on the market and we have flights booked for
the end of July.

The problem is that the move is becoming so much work that I barely
have time to sit down with the computer, let alone handle patches. It
probably isn't going to get any better either until the kids are
settled in their new school (mid August).  I need help to prepare for
the next merge window, and quite possibly the next window.  Since you
three have agreed to co-maintain those subsystems with me, can you
please take a look at the patches that have been posted, pick up the
ones that look ready to go to you, and get them into linux-next?  I
may even need you to send pull requests to Linus when the window opens
if I'm still under water.

Also, if you have any bug fixes that need to go into v3.5, go ahead
and send them on to Linus directly (Rob, I think I saw a pull request
from you).

Things will definitely be better after the move is finished and
ksummit/plumbers is over.  Until then, thanks in advance for anything
you can do to help with the load.

g.
