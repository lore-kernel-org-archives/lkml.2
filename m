Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373Ab0INIcK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 04:32:10 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47513 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328Ab0INIcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 04:32:07 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH 08/17] writeback: account per-bdi accumulated written pages
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Dave Chinner <david@fromorbit.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mel@csn.ul.ie>,
        Rik van Riel <riel@redhat.com>, Chris Mason <chris.mason@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Li Shaohua <shaohua.li@intel.com>
In-Reply-To: <20100912155203.815667143@intel.com>
References: <20100912154945.758129106@intel.com> <20100912155203.815667143@intel.com>
Message-Id: <20100914173145.C9B8.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 14 Sep 2010 17:32:03 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Introduce the BDI_WRITTEN counter. It will be used for estimating the
> bdi's write bandwidth.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>

I like this patch :-)
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



