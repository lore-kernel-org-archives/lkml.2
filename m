Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941Ab2IGPRH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 11:17:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53866 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753297Ab2IGPRD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 11:17:03 -0400
Date: Fri, 7 Sep 2012 17:16:56 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID
Message-ID: <alpine.LNX.2.00.1209071714350.21679@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git upstream-fixes

to receive the -rc updates for HID code below.

It contains a fix for Eaton Ellipse MAX UPS from Alan Stern, performance 
improvement (not processing debug data if noone is interested), by Henrik 
Rydberg, and allowing tpkbd-driven devices to work even with generic 
driver in a crippled mode, by Andres Freund.

Thanks.

Alan Stern (1):
      HID: add NOGET quirk for Eaton Ellipse MAX UPS

Andres Freund (1):
      HID: tpkbd: work even if the new Lenovo Keyboard driver is not configured

Henrik Rydberg (1):
      HID: Only dump input if someone is listening

 drivers/hid/hid-core.c          |    7 +++++--
 drivers/hid/usbhid/hid-quirks.c |    1 +
 2 files changed, 6 insertions(+), 2 deletions(-)

-- 
Jiri Kosina
SUSE Labs
