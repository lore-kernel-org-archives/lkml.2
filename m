Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758811Ab0I0HDA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 03:03:00 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51264 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754250Ab0I0HC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 03:02:58 -0400
Date: Mon, 27 Sep 2010 09:02:51 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andi Kleen <andi@firstfloor.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: linux-next: build warning after merge of the final tree (hwpoison tree related)
Message-ID: <20100927070251.GB21952@one.firstfloor.org>
References: <20100927152804.57c2d66e.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100927152804.57c2d66e.sfr@canb.auug.org.au>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 27, 2010 at 03:28:04PM +1000, Stephen Rothwell wrote:
> Hi Andi,
> 
> After merging the final tree, today's linux-next build (powerpc
> ppc64_defconfig) produced this warning:
> 
> mm/hugetlb.c:2950: warning: 'is_hugepage_on_freelist' defined but not used
> 
> Introduced by commit 19b31e29073e272e49a3d38972c132c49383d5d4 ("HWPOISON,
> hugetlb: add free check to dequeue_hwpoison_huge_page()").

Fixed now. Thanks for the report.
-Andi
