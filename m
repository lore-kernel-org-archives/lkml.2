Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885Ab2DTJxG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 05:53:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60471 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751494Ab2DTJxF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 05:53:05 -0400
Date: Fri, 20 Apr 2012 11:53:02 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID
Message-ID: <alpine.LNX.2.00.1204201149400.29484@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive fix for one particular device and change of 'default y' -> 
'default n' for CONFIG_HID_BATTERY_STRENGTH which I have overlooked in the 
initial merge of the battery support.

Thanks.

Jiri Kosina (1):
      HID: tivo: fix support for bluetooth version of tivo Slide

Josh Boyer (1):
      HID: default HID_BATTERY_STRENGTH to no

 drivers/hid/Kconfig    |    2 +-
 drivers/hid/hid-tivo.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)
