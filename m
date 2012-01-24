Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563Ab2AXWwc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 17:52:32 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48850 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752392Ab2AXWwa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 17:52:30 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [Announce] linux-pm tree changes
Date: Tue, 24 Jan 2012 23:56:04 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc1+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201201242356.04244.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'd like you to know some workflow changes regarding the linux-pm tree.

Since it's now possible to create signed tags for Linus to pull from, I won't
need the 'pm-for-linus' branch any more and it's gone.  The 'pm-fixes' branch
is gone too and replaced by the 'fixes' branch (which currently contains the
same material as master).

The idea is that the main development is going to happen in the 'master'
branch, which is not going to be rebased and the Linus' tree will be merged
into it from time to time (most of the time when the 'master' branch can be
fast-forwarded to it).  The 'fixes' branch will be used for pushing urgent 
stuff that must go in before the new material in the 'master' branch.

The linux-next branch is going to be based on top of the master branch
with the 'fixes' branch merged into it and will contain additional new
material that hasn't been added to the master branch yet.  Every patch
going through linux-pm has to spend some time in the linux-next branch
alone before it is added to the master (or 'fixes') branch (some super-urgent
fixes may go directly to the 'fixes' branch, though).

Topic branches are all gone now and they will be re-created as needed.

If you have any questions, please ask.

Thanks,
Rafael
