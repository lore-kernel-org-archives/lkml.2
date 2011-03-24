Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933067Ab1CXDNO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 23:13:14 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:65452 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932207Ab1CXDNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 23:13:13 -0400
Date: Wed, 23 Mar 2011 23:12:50 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [GIT] idle patch for 2.6.39-merge
Message-id: <alpine.LFD.2.02.1103232306511.3848@x980>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-idle-2.6.git idle-release

This will update the file shown below.

thanks!

Len Brown
Intel Open Source Technology Center

ps. individual patches are available on linux-pm@lists.linux-foundation.org

 drivers/idle/intel_idle.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

through these commits:

Thomas Renninger (1):
      intel_idle: Rename cpuidle states

with this log:

commit 15e123e5d7e8ee9ba3717e743d8eb5fd0fe57712
Author: Thomas Renninger <trenn@suse.de>
Date:   Sun Feb 27 22:36:43 2011 +0100

    intel_idle: Rename cpuidle states
    
    Userspace apps might have to cut off parts off the
    idle state name for display reasons.
    Switch NHM-C1 to C1-NHM (and others) so that a cut off
    name is unique and makes sense to the user.
    
    Signed-off-by: Thomas Renninger <trenn@suse.de>
    CC: lenb@kernel.org
    Signed-off-by: Len Brown <len.brown@intel.com>
