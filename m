Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759496Ab1EBWs5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 18:48:57 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:56707 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759427Ab1EBWsy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 18:48:54 -0400
Subject: Re: [PATCH 1/4] mm: Remove dependency on CONFIG_FLATMEM from
 online_page()
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Daniel Kiper <dkiper@net-space.pl>
Cc: ian.campbell@citrix.com, akpm@linux-foundation.org, andi.kleen@intel.com,
        haicheng.li@linux.intel.com, fengguang.wu@intel.com, jeremy@goop.org,
        konrad.wilk@oracle.com, dan.magenheimer@oracle.com,
        v.tolstov@selfip.ru, pasik@iki.fi, wdauchy@gmail.com,
        rientjes@google.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20110502221857.GJ4623@router-fw-old.local.net-space.pl>
References: <20110502211915.GB4623@router-fw-old.local.net-space.pl>
	 <1304371504.30823.45.camel@nimitz>
	 <20110502221857.GJ4623@router-fw-old.local.net-space.pl>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Mon, 02 May 2011 15:48:48 -0700
Message-ID: <1304376528.30823.47.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-03 at 00:18 +0200, Daniel Kiper wrote:
> 
> > config MEMORY_HOTPLUG
> >         bool "Allow for memory hot-add"
> >         depends on SPARSEMEM || X86_64_ACPI_NUMA
> >         depends on HOTPLUG && ARCH_ENABLE_MEMORY_HOTPLUG
> >         depends on (IA64 || X86 || PPC_BOOK3S_64 || SUPERH || S390)
> 
> IIRC some time ago it was possible to enable memory hotplug with
> CONFIG_FLATMEM. That is why I looked for any dependencies of memory
> hoplug code on CONFIG_FLATMEM in current Linux Kernel source. I could
> not find anything and that is why I published this patch. However,
> maybe I missed something.

I can't find any immediately apparent case, either.  Guess that's what
LKML is for. :)

Acked-by: Dave Hansen <dave@linux.vnet.ibm.com>

-- Dave

