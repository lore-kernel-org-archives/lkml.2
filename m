Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783Ab0FDT0b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 15:26:31 -0400
Received: from vms173013pub.verizon.net ([206.46.173.13]:37232 "EHLO
	vms173013pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770Ab0FDT0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 15:26:30 -0400
Date: Fri, 04 Jun 2010 15:26:25 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: sfi-devel@simplefirmware.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [git pull request] SFI patch for 2.6.31-rc1
Message-id: <alpine.LFD.2.00.1006041524380.4073@localhost.localdomain>
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
http://ftp.kernel.org/pub/linux/kernel/people/lenb/sfi/patches/2.6.35/acpi-sfi-release-20100428-2.6.35-rc1.diff.gz

 drivers/sfi/sfi_core.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

through these commits:

Dan Carpenter (1):
      SFI: do not return freed pointer

with this log:

commit e29df91e67428c1a651d18df6ec047fcb30282d3
Author: Dan Carpenter <error27@gmail.com>
Date:   Fri May 28 12:33:15 2010 +0200

    SFI: do not return freed pointer
    
    We never actually use the return value of sfi_sysfs_install_table() but
    it still seems wrong to return a freed pointer.
    
    Signed-off-by: Dan Carpenter <error27@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>
