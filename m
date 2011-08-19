Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730Ab1HSDyW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 23:54:22 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:35051 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695Ab1HSDyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 23:54:21 -0400
Message-ID: <4E4DDE68.6060308@gmail.com>
Date: Thu, 18 Aug 2011 23:54:16 -0400
From: Andrew Buehler <abuehler.kernel@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: Kernel development list <linux-kernel@vger.kernel.org>
Subject: Thanks and congratulations for improved support
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I first got my current laptop and installed Linux on it - somewhere
between one and two years ago - there were a number of less than ideal
behaviors, which seem in hindsight to have potentially been
kernel-related. Wireless connections would bounce up and down at random
intervals (sometimes as little as a few seconds apart), suspending even
to RAM would take 15-45 seconds freezing processes and then another
10-15 suspending consoles, and connecting or unplugging a USB device
during the process of suspending would abort the suspend - this last,
apparently, because a new process was triggered which would not freeze.

I found workarounds for the wireless problems, got used to the suspend
slowness, and took an "if it hurts to do that, don't do that" approach
to the USB disconnect-while-suspending problem - and I kept going,
upgrading my kernel and various other software on a fairly regular
basis. After a while, I noticed that the time needed to suspend had gone
down; another while later, I noticed that my "stand on one leg and
whistle 'I Am My Own Grandpa' backwards" wireless workaround script
wasn't necessary anymore.

By now, suspending to RAM takes five seconds or less most of the time -
and just this past evening (coincidentally enough, not long after having
rebooted into kernel 3.0.0), I accidentally unplugged a USB mouse while
suspending, and was pleasantly surprised to find that the suspend did
not abort but completed without problems. As of this moment, as far as I
know, all of the various problems I've had with this laptop under Linux
are gone.

So I just wanted to take a moment to say: thank you for the fixes,
congratulations on the improvements, and keep up the good work!

-- 
   Andrew J. Buehler
