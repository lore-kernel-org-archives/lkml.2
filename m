Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119Ab2B1AG4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 19:06:56 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36732 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754297Ab2B1AGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 19:06:55 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 28 Feb 2012 09:05:26 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v3 01/21] memcg: unify inactive_ratio calculation
Message-Id: <20120228090526.201b4e9d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20120223135141.12988.12236.stgit@zurg>
References: <20120223133728.12988.5432.stgit@zurg>
	<20120223135141.12988.12236.stgit@zurg>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Feb 2012 17:51:41 +0400
Konstantin Khlebnikov <khlebnikov@openvz.org> wrote:

> This patch removes precalculated zone->inactive_ratio.
> Now it always calculated in inactive_anon_is_low() from current lru sizes.
> After that we can merge memcg and non-memcg cases and drop duplicated code.
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>

seems good to me.

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

