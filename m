Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757683Ab1EBVTd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 17:19:33 -0400
Received: from router-fw.net-space.pl ([89.174.63.77]:46417 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757331Ab1EBVTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 17:19:30 -0400
Date: Mon, 2 May 2011 23:18:06 +0200
From: Daniel Kiper <dkiper@net-space.pl>
To: ian.campbell@citrix.com, akpm@linux-foundation.org, andi.kleen@intel.com,
        haicheng.li@linux.intel.com, fengguang.wu@intel.com, jeremy@goop.org,
        konrad.wilk@oracle.com, dan.magenheimer@oracle.com,
        v.tolstov@selfip.ru, pasik@iki.fi, dave@linux.vnet.ibm.com,
        wdauchy@gmail.com, rientjes@google.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 0/4] mm: Memory hotplug and sparsemem cleanups
Message-ID: <20110502211806.GA4623@router-fw-old.local.net-space.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Full list of cleanups:
  - mm: Remove dependency on CONFIG_FLATMEM from online_page(),
  - mm: Enable set_page_section() only if CONFIG_SPARSEMEM
    and !CONFIG_SPARSEMEM_VMEMMAP,
  - mm: pfn_to_section_nr()/section_nr_to_pfn() is valid
    only in CONFIG_SPARSEMEM context,
  - mm: Do not define PFN_SECTION_SHIFT if !CONFIG_SPARSEMEM.

Those patches applies to Linus' git tree, v2.6.39-rc5 tag.
They are required by latest memory hotplug support for Xen balloon
driver patch which will be sent soon.

Daniel
