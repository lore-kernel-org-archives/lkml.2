Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758708Ab2CCAYr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 19:24:47 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63211 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758590Ab2CCAYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 19:24:45 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of hughd@google.com designates 10.68.227.105 as permitted sender) smtp.mail=hughd@google.com; dkim=pass header.i=hughd@google.com
Date: Fri, 2 Mar 2012 16:24:16 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <jweiner@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] mm: push lru index into shrink_[in]active_list()
In-Reply-To: <20120229091551.29236.27110.stgit@zurg>
Message-ID: <alpine.LSU.2.00.1203021623190.3578@eggly.anvils>
References: <20120229090748.29236.35489.stgit@zurg> <20120229091551.29236.27110.stgit@zurg>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Feb 2012, Konstantin Khlebnikov wrote:

> Let's toss lru index through call stack to isolate_lru_pages(),
> this is better than its reconstructing from individual bits.
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>

Yes, this is an improvement, thanks:

Acked-by: Hugh Dickins <hughd@google.com>
