Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751439Ab0CSHSp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 03:18:45 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:52582 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224Ab0CSHSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 03:18:43 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 19 Mar 2010 16:15:04 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org, andi.kleen@intel.com, fengguang.wu@intel.com
Subject: Re: [PATCH 1/2] pagemap: add #ifdefs CONFIG_HUGETLB_PAGE on code
 walking hugetlb vma
Message-Id: <20100319161504.2c5c65b5.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100319065334.GB12389@spritzerA.linux.bs1.fc.nec.co.jp>
References: <1268979996-12297-1-git-send-email-n-horiguchi@ah.jp.nec.com>
	<20100319152934.c4243698.kamezawa.hiroyu@jp.fujitsu.com>
	<20100319065334.GB12389@spritzerA.linux.bs1.fc.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Mar 2010 15:53:34 +0900
Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:

> On Fri, Mar 19, 2010 at 03:29:34PM +0900, KAMEZAWA Hiroyuki wrote:
> > On Fri, 19 Mar 2010 15:26:35 +0900
> > Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:
> > 
> > > If !CONFIG_HUGETLB_PAGE, pagemap_hugetlb_range() is never called.
> > > So put it (and its calling function) into #ifdef block.
> > > 
> > > Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> > 
> > Hmm? What is benefit ? Is this broken now ?
> > 
> 
> Not broken, but this is needed to avoid build error with patch 2/2 applied,
> where I move huge_pte_offset() (not defined when !HUGETLB_PAGE)
> into pagemap_hugetlb_range().
> 

I think this should be merged with 2/2....if necessary.

Thanks,
-Kame

