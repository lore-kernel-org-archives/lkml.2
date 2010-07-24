Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457Ab0GXKFy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jul 2010 06:05:54 -0400
Received: from torres.zugschlus.de ([85.214.131.164]:40434 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941Ab0GXKFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jul 2010 06:05:52 -0400
X-Greylist: delayed 2347 seconds by postgrey-1.27 at vger.kernel.org; Sat, 24 Jul 2010 06:05:52 EDT
Date: Sat, 24 Jul 2010 11:26:44 +0200
From: Marc Haber <mh+linux-kernel@zugschlus.de>
To: Linux Kernel Developers <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: e1000e crashes with 2.6.34.x and ThinkPad T60
Message-ID: <20100724092644.GA13353@torres.zugschlus.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a new notebook, a Thinkpad T60, which is freezing in random
intervals (like 30 minutes to two days) as long as I am using the
on-board wired ethernet interface, which is an e1000e, [8086:109a]. As
long as I keep using the WLAN, the system runs for weeks despite
frequent suspend/resume cycles etc. The crashes seem really to be tied
to using the wired ethernet. This is a hard freeze, with nothing
happening on the system, only a long push on the power button helps.

Additionally, sometimes, probably after suspend/resume, the wired
ethernet does not come up properly again, ip addr claims "NO CARRIER"
even if the LEDs on the interface and on the switch claim that there
was a link. No packets are received by the interface when it's at this
stage.

Both issues appear with 2.6.34 and 2.6.34.1. I didn't try any of these
issues with an older kernel, 2.6.34 was already out when I started
using the T60.

To rule out defective hardware, I have tried with a second T60, with
the same results.

Full dmesg and lspci-nn attached, please say if you need more.

Greetings
Marc

P.S.: Please Cc: me on replies, both linux-kernel and netdev are too
big for me to timely follow. I am subscribed to both lists, but a Cc
helps in getting a faster reply.

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Mannheim, Germany  |  lose things."    Winona Ryder | Fon: *49 621 72739834
Nordisch by Nature |  How to make an American Quilt | Fax: *49 3221 2323190
