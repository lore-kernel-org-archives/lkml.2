Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751038Ab1CQEOb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 00:14:31 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54069 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822Ab1CQEO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 00:14:28 -0400
Date: Thu, 17 Mar 2011 05:14:24 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Huang Ying <ying.huang@intel.com>,
        Jin Dongming <jin.dongming@np.css.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] Check whether pages are poisoned before copying
Message-ID: <20110317041424.GD11094@one.firstfloor.org>
References: <4D817234.9070106@jp.fujitsu.com> <4D8172D7.3040201@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D8172D7.3040201@jp.fujitsu.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 11:32:55AM +0900, Hidetoshi Seto wrote:
> So to avoid the above problem, add poison checks for both of 4K pages
> and the THP before copying in __collapse_huge_page_copy().

I don't think you need the check for the huge page -- it should not be allocated
in this case.

-Andi

