Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476Ab2CIB1p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 20:27:45 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51449 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547Ab2CIB1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 20:27:44 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 9 Mar 2012 10:26:11 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        Johannes Weiner <jweiner@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/7] mm/memcg: scanning_global_lru means
 mem_cgroup_disabled
Message-Id: <20120309102611.2f529749.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20120308180401.27621.31137.stgit@zurg>
References: <20120308175752.27621.54781.stgit@zurg>
	<20120308180401.27621.31137.stgit@zurg>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Mar 2012 22:04:01 +0400
Konstantin Khlebnikov <khlebnikov@openvz.org> wrote:

> From: Hugh Dickins <hughd@google.com>
> 
> Although one has to admire the skill with which it has been concealed,
> scanning_global_lru(mz) is actually just an interesting way to test
> mem_cgroup_disabled().  Too many developer hours have been wasted on
> confusing it with global_reclaim(): just use mem_cgroup_disabled().
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>


Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

If no changes since v4, please show Acks you got.

