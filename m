Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab1GHB67 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 21:58:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:33633 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753039Ab1GHB66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 21:58:58 -0400
Date: Fri, 8 Jul 2011 09:58:23 +0800
From: Wengang Wang <wen.gang.wang@oracle.com>
To: Hugh Dickins <hughd@google.com>
Cc: Wengang Wang <wen.gang.wang@oracle.com>, stable@kernel.org,
        greg.marsden@oracle.com, joe.jin@oracle.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: prevent concurrent unmap_mapping_range() on the same
 inode --to stable
Message-ID: <20110708015823.GB3013@laptop.jp.oracle.com>
References: <20110704020003.GA4262@laptop.us.oracle.com>
 <alpine.LSU.2.00.1107071715020.10234@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1107071715020.10234@sister.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090206.4E166460.0036:SCFSTAT5015188,ss=1,re=-4.000,fgs=0
X-Greylist: IP, sender and recipient auto-whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [140.211.167.34]); Fri, 08 Jul 2011 01:58:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hugh,
On 11-07-07 17:32, Hugh Dickins wrote:
> On Mon, 4 Jul 2011, Wengang Wang wrote:
> > 
> > Any comment on the backport?
> 
> You don't mention which release it's a backport to.
> 2.6.38 and 2.6.39 base releases and 2.6.37.6 already include the fix.
> 
> It could be valuable to backport to the -longterm releases,
> but a simple rediff would not be enough: things moved around.
> 

I re-sent the patch mentioning it needs to be in 2.6.32.
Sorry for confusing!

regards,
wengang.
