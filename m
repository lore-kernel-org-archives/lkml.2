Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524Ab2KHNBV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 08:01:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53133 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751665Ab2KHNBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 08:01:20 -0500
Date: Thu, 8 Nov 2012 14:01:16 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID
Message-ID: <alpine.LNX.2.00.1211081357510.27271@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

It reverts a patch that causes regression in binding between HID devices 
and drivers during device unplug/replug cycle.

Thanks.

Jiri Kosina (1):
      HID: hidraw: put old deallocation mechanism in place

 drivers/hid/hidraw.c |   69 +++++++++++++++++++++++++++++++-------------------
 1 files changed, 43 insertions(+), 26 deletions(-)

-- 
Jiri Kosina
SUSE Labs
