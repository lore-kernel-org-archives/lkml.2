Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab2CMFPc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 01:15:32 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38281 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917Ab2CMFPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 01:15:31 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 13 Mar 2012 14:13:52 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hugh Dickins <hughd@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Hillf Danton <dhillf@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] memcg: revert fix to mapcount check for this release
Message-Id: <20120313141352.e390056f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.LSU.2.00.1203091335020.19372@eggly.anvils>
References: <1330719189-20047-1-git-send-email-n-horiguchi@ah.jp.nec.com>
	<1330719189-20047-2-git-send-email-n-horiguchi@ah.jp.nec.com>
	<20120309101658.8b36ce4f.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.LSU.2.00.1203081816170.18242@eggly.anvils>
	<20120309122448.92931dc6.kamezawa.hiroyu@jp.fujitsu.com>
	<20120309150109.51ba8ea1.nishimura@mxp.nes.nec.co.jp>
	<20120309162357.71c8c573.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.LSU.2.00.1203091225440.19372@eggly.anvils>
	<alpine.LSU.2.00.1203091335020.19372@eggly.anvils>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Mar 2012 13:37:32 -0800 (PST)
Hugh Dickins <hughd@google.com> wrote:

> Respectfully revert commit e6ca7b89dc76 "memcg: fix mapcount check
> in move charge code for anonymous page" for the 3.3 release, so that
> it behaves exactly like releases 2.6.35 through 3.2 in this respect.
> 
> Horiguchi-san's commit is correct in itself, 1 makes much more sense
> than 2 in that check; but it does not go far enough - swapcount
> should be considered too - if we really want such a check at all.
> 
> We appear to have reached agreement now, and expect that 3.4 will
> remove the mapcount check, but had better not make 3.3 different.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

