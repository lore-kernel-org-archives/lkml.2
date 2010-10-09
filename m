Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760203Ab0JICvq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 22:51:46 -0400
Received: from vms173017pub.verizon.net ([206.46.173.17]:58104 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760141Ab0JICvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 22:51:45 -0400
Date: Fri, 08 Oct 2010 22:51:33 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Power Management List <linux-pm@lists.osdl.org>
Subject: [git pull request] idle patch for Linux-2.6.36-rc7
Message-id: <alpine.LFD.2.00.1010082247110.3961@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-idle-2.6.git idle-release

This fixes a 'regression' seen by those switching to
2.6.35's new intel_idle driver from 2.6.34's acpi_idle driver
if they are running on some Atom Z-series.

I had disabled ATM-C6 in Atom pending public documentation.

This will update the files shown below.

thanks!

--
Len Brown
Intel Open Source Technology Center


ps. individual patches are available on linux-pm@lists.linux-foundation.org
and a consolidated plain patch is available here:
http://ftp.kernel.org/pub/linux/kernel/people/lenb/idle/patches/2.6.36/idle-release-2.6.36-rc7.diff.gz

 drivers/idle/intel_idle.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

through these commits:

Len Brown (1):
      intel_idle: enable Atom C6

with this log:

commit c7d96d8ee49e5020e4c5e73687c068dbdca2a4e8
Author: Len Brown <len.brown@intel.com>
Date:   Tue Oct 5 13:43:14 2010 -0400

    intel_idle: enable Atom C6
    
    ATM-C6 was commented out, pending public documentation.
    
    https://bugzilla.kernel.org/show_bug.cgi?id=19762
    
    Tested-by: Dennis Jansen <Dennis.Jansen@...>
    Signed-off-by: Len Brown <len.brown@intel.com>
