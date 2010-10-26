Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933542Ab0JZTPJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 15:15:09 -0400
Received: from vms173019pub.verizon.net ([206.46.173.19]:50646 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933504Ab0JZTPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 15:15:07 -0400
Date: Tue, 26 Oct 2010 15:14:48 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, sfi-devel@simplefirmware.org
Subject: [git pull request] SFI patch for 2.6.37-merge
Message-id: <alpine.LFD.2.00.1010261512160.11689@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-sfi-2.6.git sfi-release

This will update the file shown below.

thanks!

--
Len Brown
Intel Open Source Technology Center


ps. individual patches are available on sfi-devel@simplefirmware.org
and a consolidated plain patch is available here:
http://ftp.kernel.org/pub/linux/kernel/people/lenb/sfi/patches/2.6.36/acpi-sfi-release-20100702-2.6.36-rc8.diff.gz

 include/linux/sfi.h |   24 ------------------------
 1 files changed, 0 insertions(+), 24 deletions(-)

through these commits:

Feng Tang (1):
      SFI: remove the v0.7 related definitions from sfi.h

with this log:

commit 82acf2a8fe4764e21a7ad406590453b004751e58
Author: Feng Tang <feng.tang@intel.com>
Date:   Tue Oct 19 10:15:03 2010 +0800

    SFI: remove the v0.7 related definitions from sfi.h
    
    SFI v0.8's DEVS and GPIO tables replaces v0.7's SPI/I2C tables.
    
    Signed-off-by: Feng Tang <feng.tang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>
