Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759243Ab1EBWuV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 18:50:21 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:42390 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755221Ab1EBWuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 18:50:20 -0400
Subject: Re: [PATCH 2/4] mm: Enable set_page_section() only if
 CONFIG_SPARSEMEM and !CONFIG_SPARSEMEM_VMEMMAP
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Daniel Kiper <dkiper@net-space.pl>
Cc: ian.campbell@citrix.com, akpm@linux-foundation.org, andi.kleen@intel.com,
        haicheng.li@linux.intel.com, fengguang.wu@intel.com, jeremy@goop.org,
        konrad.wilk@oracle.com, dan.magenheimer@oracle.com,
        v.tolstov@selfip.ru, pasik@iki.fi, wdauchy@gmail.com,
        rientjes@google.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20110502212012.GC4623@router-fw-old.local.net-space.pl>
References: <20110502212012.GC4623@router-fw-old.local.net-space.pl>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Mon, 02 May 2011 15:50:14 -0700
Message-ID: <1304376614.30823.48.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-02 at 23:20 +0200, Daniel Kiper wrote:
> set_page_section() is valid only in CONFIG_SPARSEMEM and
> !CONFIG_SPARSEMEM_VMEMMAP context. Move it to proper place
> and amend accordingly functions which are using it.

I guess we've been wasting all that time setting section bits in
page->flags that we'll never use.  Looks sane to me.

Acked-by: Dave Hansen <dave@linux.vnet.ibm.com>

-- Dave

