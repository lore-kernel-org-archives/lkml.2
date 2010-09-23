Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287Ab0IWQCR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 12:02:17 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:42515 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752760Ab0IWQCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 12:02:16 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: afUF5twVM1nZCdPJPoJWDDhvDLctdPsbEauXBttZ_SUuCs_
 F4c..RwQBWLH_3U3wfNsohxVFVI5YAH1SJ4Kc7djMaGogHsVcEKUgY7Xv2lP
 oZSXoJBUHuN6j5tr2Dpv9ybwUaVMC..F4KdyVSiQg.zTDSpo.b47c3zfZAm9
 g3MYgwUQEOvaEQzcDv0Mh.HoTqPFfBpPBMtIHROAO1RgaVjXVz1Bs1gsocye
 fYMAuszWkFTzoJHoiNatgXYFA9LdsEJmqCQ--
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 23 Sep 2010 11:02:12 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Mel Gorman <mel@csn.ul.ie>
cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        tony.luck@intel.com
Subject: Re: [PATCH 02/10] hugetlb: add allocate function for hugepage
 migration
In-Reply-To: <20100923084919.GA5185@csn.ul.ie>
Message-ID: <alpine.DEB.2.00.1009231100440.32567@router.home>
References: <1283908781-13810-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1283908781-13810-3-git-send-email-n-horiguchi@ah.jp.nec.com> <alpine.DEB.2.00.1009221558000.32661@router.home> <20100923084919.GA5185@csn.ul.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Sep 2010, Mel Gorman wrote:

> Are you sure about this case? The virtual address of the page being migrated
> should not changed, only the physical address.

Right. I see that he just extracts a portion of the function. Semantics
of the alloc functions are indeed preserved.

Reviewed-by: Christoph Lameter <cl@linux.com>

