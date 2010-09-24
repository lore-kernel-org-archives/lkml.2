Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750914Ab0IXEWf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 00:22:35 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:50044 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab0IXEWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 00:22:34 -0400
Date: Fri, 24 Sep 2010 12:24:15 +0900
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Christoph Lameter <cl@linux.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Wu Fengguang <fengguang.wu@intel.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/10] hugetlb: redefine hugepage copy functions
Message-ID: <20100924032415.GA26639@spritzera.linux.bs1.fc.nec.co.jp>
References: <1283908781-13810-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1283908781-13810-4-git-send-email-n-horiguchi@ah.jp.nec.com>
 <alpine.DEB.2.00.1009231114030.32567@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1009231114030.32567@router.home>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 23, 2010 at 11:21:25AM -0500, Christoph Lameter wrote:
> On Wed, 8 Sep 2010, Naoya Horiguchi wrote:
> 
> > This patch modifies hugepage copy functions to have only destination
> > and source hugepages as arguments for later use.
> > The old ones are renamed from copy_{gigantic,huge}_page() to
> > copy_user_{gigantic,huge}_page().
> > This naming convention is consistent with that between copy_highpage()
> > and copy_user_highpage().
> 
> Looking at copy_user_highpage(): The vma parameter does not seem to be
> used anywhere anymore? The vaddr is used on arches that have virtual
> caching.
> 
> Maybe removing the vma parameter would allow to simplify the hugetlb
> code?

That's right.
I'll do this cleanup (although it may be aside from this patchset.)

> Reviewed-by: Christoph Lameter <cl@linux.com>

Thank you.

- Naoya Horiguchi
