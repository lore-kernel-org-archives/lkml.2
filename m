Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479Ab1ECQK0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 12:10:26 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:55107 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752134Ab1ECQKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 12:10:25 -0400
Subject: Re: [PATCH 4/4] mm: Do not define PFN_SECTION_SHIFT if
 !CONFIG_SPARSEMEM
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Daniel Kiper <dkiper@net-space.pl>
Cc: ian.campbell@citrix.com, akpm@linux-foundation.org, andi.kleen@intel.com,
        haicheng.li@linux.intel.com, fengguang.wu@intel.com, jeremy@goop.org,
        konrad.wilk@oracle.com, dan.magenheimer@oracle.com,
        v.tolstov@selfip.ru, pasik@iki.fi, wdauchy@gmail.com,
        rientjes@google.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20110502212226.GE4623@router-fw-old.local.net-space.pl>
References: <20110502212226.GE4623@router-fw-old.local.net-space.pl>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Tue, 03 May 2011 09:10:12 -0700
Message-ID: <1304439012.30823.62.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-02 at 23:22 +0200, Daniel Kiper wrote:
> Do not define PFN_SECTION_SHIFT if !CONFIG_SPARSEMEM.
> 
> Signed-off-by: Daniel Kiper <dkiper@net-space.pl> 

I'd like if this was a bit easier to verify that it didn't break
anything.  Basically, we should probably limit direct use of
PFN_SECTION_SHIFT to inside #ifdefs in headers.

But, if something is truly using this today, it's probably broken.  It's
easy enough to work around if someone hits it, I guess.

Acked-by: Dave Hansen <dave@linux.vnet.ibm.com>

-- Dave

