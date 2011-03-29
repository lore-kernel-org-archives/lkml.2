Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580Ab1C2OaG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 10:30:06 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:62903 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab1C2OaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 10:30:03 -0400
X-IronPort-AV: E=Sophos;i="4.63,262,1299456000"; 
   d="scan'208";a="5028512"
Subject: Re: [PATCH 0/4] xen/balloon: Cleanups and fixes for 2.6.40
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Daniel Kiper <dkiper@net-space.pl>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "andi.kleen@intel.com" <andi.kleen@intel.com>,
        "haicheng.li@linux.intel.com" <haicheng.li@linux.intel.com>,
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "Dan Magenheimer" <dan.magenheimer@oracle.com>,
        "v.tolstov@selfip.ru" <v.tolstov@selfip.ru>,
        "pasik@iki.fi" <pasik@iki.fi>,
        "dave@linux.vnet.ibm.com" <dave@linux.vnet.ibm.com>,
        "wdauchy@gmail.com" <wdauchy@gmail.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Daniel De Graaf <dgdegra@tycho.nsa.gov>
In-Reply-To: <20110328093128.GE13826@router-fw-old.local.net-space.pl>
References: <20110328093128.GE13826@router-fw-old.local.net-space.pl>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Tue, 29 Mar 2011 15:30:01 +0100
Message-ID: <1301409001.18413.11.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-03-28 at 10:31 +0100, Daniel Kiper wrote:
> Hi,
> 
> Full list of cleanups/fixes:
>   - xen/balloon: Use PageHighMem() for high memory page detection,
>   - xen/balloon: Simplify HVM integration,
>   - xen/balloon: Clarify credit calculation,
>   - xen/balloon: Move dec_totalhigh_pages() from __balloon_append() to balloon_append().
> 
> Those patches applies to latest Linus' git tree
> (git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git).
> They are required by latest memory hotplug support for Xen balloon
> driver patch which will be sent soon.

This series looks sane to me, so:
Acked-by: Ian Campbell <ian.campbell@citrix.com>

CC'ing Daniel De Graaf though since he has been working on the balloon
driver recently as well.

Ian.


