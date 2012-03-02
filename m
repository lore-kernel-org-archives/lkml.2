Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713Ab2CBFXM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 00:23:12 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44971 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488Ab2CBFXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 00:23:11 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 2 Mar 2012 14:21:38 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        Johannes Weiner <jweiner@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] mm: push lru index into shrink_[in]active_list()
Message-Id: <20120302142138.f5e925a8.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20120229091551.29236.27110.stgit@zurg>
References: <20120229090748.29236.35489.stgit@zurg>
	<20120229091551.29236.27110.stgit@zurg>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Feb 2012 13:15:52 +0400
Konstantin Khlebnikov <khlebnikov@openvz.org> wrote:

> Let's toss lru index through call stack to isolate_lru_pages(),
> this is better than its reconstructing from individual bits.
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>

I like this.

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


