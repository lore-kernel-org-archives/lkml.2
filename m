Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932924Ab2AEVjO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 16:39:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35455 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758360Ab2AEVjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 16:39:10 -0500
Date: Thu, 5 Jan 2012 22:39:09 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] APM
Message-ID: <alpine.LNX.2.00.1201052220020.24984@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/apm.git for-linus

to receive one simple dependency fix for APM.

Thank you.

Paul Bolle (1):
      x86: Kconfig: drop unknown symbol 'APM_MODULE'

 arch/x86/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

-- 
Jiri Kosina
SUSE Labs

