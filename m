Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511Ab1AaX5M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 18:57:12 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37589 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756475Ab1AaX5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 18:57:10 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 1 Feb 2011 08:51:06 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: akpm@linux-foundation.org, nishimura@mxp.nes.nec.co.jp,
        balbir@linux.vnet.ibm.com, minchan.kim@gmail.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 3/3] memcg: never OOM when charging huge pages
Message-Id: <20110201085106.790e5f65.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1296482635-13421-4-git-send-email-hannes@cmpxchg.org>
References: <1296482635-13421-1-git-send-email-hannes@cmpxchg.org>
	<1296482635-13421-4-git-send-email-hannes@cmpxchg.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Jan 2011 15:03:55 +0100
Johannes Weiner <hannes@cmpxchg.org> wrote:

> Huge page coverage should obviously have less priority than the
> continued execution of a process.
> 
> Never kill a process when charging it a huge page fails.  Instead,
> give up after the first failed reclaim attempt and fall back to
> regular pages.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu,com>

