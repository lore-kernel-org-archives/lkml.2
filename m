Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580Ab1HBWkU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 18:40:20 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:43648 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307Ab1HBWkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 18:40:17 -0400
Date: Tue, 02 Aug 2011 18:40:15 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: [GIT PATCH] tools/power patches for Linux 3.1
Message-id: <alpine.LFD.2.02.1108021838520.25237@x980>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-idle-2.6.git tools-release

This will update the files shown below.

thanks!

Len Brown
Intel Open Source Technology Center

ps. individual patches are available on linux-pm@lists.linux-foundation.org

 tools/power/x86/turbostat/turbostat.c              |   46 ++++++++++----------
 .../x86_energy_perf_policy.c                       |    5 +-
 2 files changed, 25 insertions(+), 26 deletions(-)

through these commits:

Len Brown (2):
      tools/power x86_energy_perf_policy: fix print of uninitialized string
      tools/power turbostat: fit output into 80 columns on snb-ep

with this log:

commit d30c4b7a87e8b19583d5ef1402d9b38f51e30f44
Author: Len Brown <len.brown@intel.com>
Date:   Sun Jul 31 18:19:33 2011 -0400

    tools/power turbostat: fit output into 80 columns on snb-ep
    
    Reduce columns for package number to 1.
    If you can afford more than 9 packages,
    you can also afford a terminal with more than 80 columns:-)
    
    Also shave a column also off the package C-states
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e4c0d0e22ce5cf84b3993b5af6c2dac08d52f06b
Author: Len Brown <len.brown@intel.com>
Date:   Fri Jul 15 23:39:00 2011 -0400

    tools/power x86_energy_perf_policy: fix print of uninitialized string
    
    Looks like I was going to stick the brand string
    in the verbose ouput, but didn't get around to it.
    
    Signed-off-by: Len Brown <len.brown@intel.com>
