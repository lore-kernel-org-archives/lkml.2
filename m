Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758372Ab2HWKKg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 06:10:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54206 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752847Ab2HWKKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 06:10:34 -0400
Date: Thu, 23 Aug 2012 12:10:27 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID
Message-ID: <alpine.LNX.2.00.1208231209280.32304@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git upstream-fixes

to receive fix for one particular device not being properly claimed by 
hid-multitouch driver.

Thanks.

Simon Farnsworth (1):
      HID: Remove QUANTA from special drivers list

 drivers/hid/hid-core.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

-- 
Jiri Kosina
SUSE Labs
