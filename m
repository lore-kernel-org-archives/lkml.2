Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756339Ab2B1AiE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 19:38:04 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49532 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756129Ab2B1AiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 19:38:02 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 28 Feb 2012 09:36:36 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v3 08/21] mm: unify inactive_list_is_low()
Message-Id: <20120228093636.239f5d75.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20120223135219.12988.94138.stgit@zurg>
References: <20120223133728.12988.5432.stgit@zurg>
	<20120223135219.12988.94138.stgit@zurg>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Feb 2012 17:52:19 +0400
Konstantin Khlebnikov <khlebnikov@openvz.org> wrote:

> Unify memcg and non-memcg logic, always use exact counters from struct lruvec.
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>

Nice.
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


