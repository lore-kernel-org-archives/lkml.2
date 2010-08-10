Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757893Ab0HJUVo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 16:21:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:6430 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757865Ab0HJUVn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 16:21:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,349,1278313200"; 
   d="scan'208";a="826449752"
Date: Wed, 11 Aug 2010 03:53:42 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/8] hugetlb: move definition of is_vm_hugetlb_page()
 to hugepage_inline.h
Message-ID: <20100810195342.GA6677@localhost>
References: <1275006562-18946-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1275006562-18946-2-git-send-email-n-horiguchi@ah.jp.nec.com>
 <20100528100350.GC9774@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100528100350.GC9774@csn.ul.ie>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +#ifndef _LINUX_HUGETLB_INLINE_H
> > +#define _LINUX_HUGETLB_INLINE_H 1
> > +
> 
> Just #define __LINUX_HUGETLB_INLINE_H is fine. No need for the 1
> 
> > +#ifdef CONFIG_HUGETLBFS
> > +
> 
> Should be CONFIG_HUGETLB_PAGE
> 
> With those corrections;
> 
> Acked-by: Mel Gorman <mel@csn.ul.ie>

Both fixed in Andi's tree, so

Acked-by: Wu Fengguang <fengguang.wu@intel.com>
