Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524Ab2KPPna (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 10:43:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47377 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752432Ab2KPPn3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 10:43:29 -0500
Date: Fri, 16 Nov 2012 16:43:25 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID
Message-ID: <alpine.LNX.2.00.1211161640560.20577@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

It contains build fix for architectures where memcmp() is macro, from Jiri 
Slaby.


Jiri Slaby (1):
      HID: microsoft: do not use compound literal - fix build

 drivers/hid/hid-microsoft.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

Thanks,

-- 
Jiri Kosina
SUSE Labs
