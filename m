Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab1C1JXg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 05:23:36 -0400
Received: from router-fw.net-space.pl ([89.174.63.77]:47213 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507Ab1C1JXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 05:23:34 -0400
Date: Mon, 28 Mar 2011 11:22:11 +0200
From: Daniel Kiper <dkiper@net-space.pl>
To: ian.campbell@citrix.com, akpm@linux-foundation.org, andi.kleen@intel.com,
        haicheng.li@linux.intel.com, fengguang.wu@intel.com, jeremy@goop.org,
        konrad.wilk@oracle.com, dan.magenheimer@oracle.com,
        v.tolstov@selfip.ru, pasik@iki.fi, dave@linux.vnet.ibm.com,
        wdauchy@gmail.com, rientjes@google.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 0/3] mm: Memory hotplug interface changes and cleanups for 2.6.40
Message-ID: <20110328092211.GA13826@router-fw-old.local.net-space.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Full list of cleanups/futures:
  - mm: Optimize pfn calculation in online_page(),
  - mm: Add SECTION_ALIGN_UP() and SECTION_ALIGN_DOWN() macro,
  - mm: Extend memory hotplug API to allow memory hotplug in virtual machines.

Those patches applies to latest Linus' git tree
(git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git).
They are required by latest memory hotplug support for Xen balloon
driver patch which will be sent soon.

Daniel
