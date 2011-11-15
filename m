Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772Ab1KOKJw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 05:09:52 -0500
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:33889 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959Ab1KOKJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 05:09:51 -0500
Subject: ARCH_PXA_ADX
From: Paul Bolle <pebolle@tiscali.nl>
To: Thierry Reding <thierry.reding@avionic-design.de>,
        Richard Purdie <rpurdie@linux.intel.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Wim Van Sebroeck <wim@iguana.be>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Nov 2011 11:09:37 +0100
Message-ID: <1321351777.20271.166.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

0) Since v2.6.32 the mainline tree supports the "Avionic Design Xanthos
Backlight Driver" (BACKLIGHT_ADX) and the "Avionic Design Xanthos
watchdog" driver (ADX_WATCHDOG). These were added in commit 3b96ea9ef8
("[...] Add support for the Avionic Design Xanthos backlight device.")
and 38461c5c08 ("[...] Add support for the Avionic Design Xanthos
watchdog timer.").

1) Both drivers' Kconfig symbols depend on the Kconfig symbol
ARCH_PXA_ADX. At that time this symbol didn't exist. It still doesn't. I
haven't been able to find anything remotely related (ie, I even did
things like "git grep -i PXA | grep -i ADX").

2) So it seems these two drivers could never have been built from the
mainline tree. (I'm starting to think that the config tools should
somehow check stuff like this.)

3) Is the above correct? If it is, why shouldn't I submit the trivial
patch to remove both these drivers?


Paul Bolle

