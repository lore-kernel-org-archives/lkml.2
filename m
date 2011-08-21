Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906Ab1HUOEX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 10:04:23 -0400
Received: from router-fw.net-space.pl ([89.174.63.77]:51373 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365Ab1HUOEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 10:04:21 -0400
X-Greylist: delayed 733 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Aug 2011 10:04:21 EDT
Date: Sun, 21 Aug 2011 15:50:29 +0200
From: Daniel Kiper <dkiper@net-space.pl>
To: konrad.wilk@oracle.com, ian.campbell@citrix.com, vgoyal@redhat.com,
        horms@verge.net.au, olaf@aepfle.de, kexec@lists.infradead.org,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] kexec-tools: Xen fixes and cleanups
Message-ID: <20110821135029.GA17323@router-fw-old.local.net-space.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am sending some Xen specific fixes and cleanups for kexec-tools.
These patches applies to current kexec-tools git tree.

Full list of fixes and cleanups:
  - xen: Take into account Xen control interface changes since Xen Ver. 4.1,
  - kexec: Export compare_ranges() function from firmware_memmap.c module,
  - kexec/arch/i386: Rename fixup_memory_ranges_sysfs() to fixup_memory_ranges(),
  - kexec/arch/i386: Add get_memory_ranges_xen() function.

Daniel
