Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756939Ab1LBQDq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 11:03:46 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34283 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756849Ab1LBQDg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 11:03:36 -0500
Date: Fri, 2 Dec 2011 17:03:33 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID
Message-ID: <alpine.LNX.2.00.1112021702040.18207@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive the commit below. It fixes product ID for one particular 
device.

Thanks.

Benjamin Tissoires (1):
      HID: Correct General touch PID

 drivers/hid/hid-core.c |    2 +-
 drivers/hid/hid-ids.h  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

-- 
Jiri Kosina
SUSE Labs

