Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190Ab0HZEWI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 00:22:08 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47086 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab0HZEWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 00:22:05 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] writeback: remove the internal 5% low bound on dirty_ratio
Cc: kosaki.motohiro@jp.fujitsu.com, Wu Fengguang <fengguang.wu@intel.com>,
        Con Kolivas <kernel@kolivas.org>, Jan Kara <jack@suse.cz>,
        Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "david@fromorbit.com" <david@fromorbit.com>, "hch@lst.de" <hch@lst.de>,
        "axboe@kernel.dk" <axboe@kernel.dk>
In-Reply-To: <20100826113649.687b453a@notabene>
References: <20100826012945.GA7859@localhost> <20100826113649.687b453a@notabene>
Message-Id: <20100826132046.F670.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 26 Aug 2010 13:22:02 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > writeback: remove the internal 5% low bound on dirty_ratio
> > 
> > The dirty_ratio was silently limited in global_dirty_limits() to >= 5%.
> > This is not a user expected behavior. And it's inconsistent with
> > calc_period_shift(), which uses the plain vm_dirty_ratio value.
> > 
> > Let's rip the internal bound.
> > 
> > At the same time, fix balance_dirty_pages() to work with the
> > dirty_thresh=0 case. This allows applications to proceed when
> > dirty+writeback pages are all cleaned.
> 
> And ">" fits with the name "exceeded" better than ">=" does.  I think it is
> an aesthetic improvement as well as a functional one.
> 
> Reviewed-by: NeilBrown <neilb@suse.de>

I agree :)
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>




