Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751151Ab0HTENd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 00:13:33 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35004 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930Ab0HTENa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 00:13:30 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH] writeback: remove the internal 5% low bound on dirty_ratio
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, riel@redhat.com, david@fromorbit.com, hch@lst.de,
        axboe@kernel.dk, Michael Rubin <mrubin@google.com>,
        Jan Kara <jack@suse.cz>, Neil Brown <neilb@suse.de>
In-Reply-To: <20100820032506.GA6662@localhost>
References: <20100820032506.GA6662@localhost>
Message-Id: <20100820131249.5FF4.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 20 Aug 2010 13:13:25 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The dirty_ratio was silently limited to >= 5%. This is not a user
> expected behavior. Let's rip it.
> 
> It's not likely the user space will depend on the old behavior.
> So the risk of breaking user space is very low.
> 
> CC: Jan Kara <jack@suse.cz>
> CC: Neil Brown <neilb@suse.de>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>

Thank you.
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



