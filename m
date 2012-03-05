Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876Ab2CEA3H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 19:29:07 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48264 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516Ab2CEA3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 19:29:05 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 5 Mar 2012 09:27:33 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        Johannes Weiner <jweiner@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7 v2] mm: rework __isolate_lru_page() file/anon filter
Message-Id: <20120305092733.78d4f433.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20120303091327.17599.80336.stgit@zurg>
References: <20120229091547.29236.28230.stgit@zurg>
	<20120303091327.17599.80336.stgit@zurg>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 03 Mar 2012 13:16:48 +0400
Konstantin Khlebnikov <khlebnikov@openvz.org> wrote:

> This patch adds file/anon filter bits into isolate_mode_t,
> this allows to simplify checks in __isolate_lru_page().
> 
> v2:
> * use switch () instead of if ()
> * fixed lumpy-reclaim isolation mode
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>

seems simple.

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

