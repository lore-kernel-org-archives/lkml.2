Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932379Ab1EQVhm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 17:37:42 -0400
Received: from router-fw.net-space.pl ([89.174.63.77]:47678 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932330Ab1EQVhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 17:37:41 -0400
Date: Tue, 17 May 2011 23:36:04 +0200
From: Daniel Kiper <dkiper@net-space.pl>
To: ian.campbell@citrix.com, akpm@linux-foundation.org, andi.kleen@intel.com,
        haicheng.li@linux.intel.com, fengguang.wu@intel.com, jeremy@goop.org,
        konrad.wilk@oracle.com, dan.magenheimer@oracle.com,
        v.tolstov@selfip.ru, pasik@iki.fi, dave@linux.vnet.ibm.com,
        wdauchy@gmail.com, rientjes@google.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH V3 0/2] mm: Memory hotplug interface changes
Message-ID: <20110517213604.GA30232@router-fw-old.local.net-space.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Full list of futures:
  - mm: Add SECTION_ALIGN_UP() and SECTION_ALIGN_DOWN() macro,
  - mm: Extend memory hotplug API to allow memory hotplug in virtual
    machines.

Those patches applies to Linus' git tree, v2.6.39-rc7 tag with a few
prerequisite patches available at https://lkml.org/lkml/2011/5/2/296.

All above mentioned patches are required by latest memory hotplug
support for Xen balloon driver patch which will be sent soon.

Daniel
