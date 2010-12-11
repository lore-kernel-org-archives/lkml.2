Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751805Ab0LKHWI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Dec 2010 02:22:08 -0500
Received: from vms173001pub.verizon.net ([206.46.173.1]:64248 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021Ab0LKHWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Dec 2010 02:22:05 -0500
Date: Sat, 11 Dec 2010 02:22:00 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: [git pull] idle patch for Linux-2.6.37-rc5
Message-id: <alpine.LFD.2.00.1012110220230.27156@x980>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-idle-2.6.git idle-release

bugfix for oversight that penalized EX systems.

This will update the file shown below.

thanks!
Len Brown
Intel Open Source Technology Center


ps. individual patches are available on linux-pm@lists.linux-foundation.org
and a consolidated plain patch is available here:
http://ftp.kernel.org/pub/linux/kernel/people/lenb/idle/patches/2.6.37/idle-release-2.6.37-rc4.diff.gz

 drivers/idle/intel_idle.c |   12 +++---------
 1 files changed, 3 insertions(+), 9 deletions(-)

through these commits:

Len Brown (1):
      intel_idle: recognize ARAT on WSM-EX

with this log:

commit 56b9aea3b740be7665be100872a913da9bdc653b
Author: Len Brown <len.brown@intel.com>
Date:   Thu Dec 2 01:19:32 2010 -0500

    intel_idle: recognize ARAT on WSM-EX
    
    We erroneously ignored the Always Running APIC Timer on WSM-EX.
    Move the check for ARAT down so that it can apply to any/all models.
    
    Signed-off-by: Len Brown <len.brown@intel.com>
