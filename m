Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981Ab1K1ApJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 19:45:09 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:54785 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752877Ab1K1ApH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 19:45:07 -0500
MIME-Version: 1.0
In-Reply-To: <1322062951-1756-4-git-send-email-hannes@cmpxchg.org>
References: <1322062951-1756-1-git-send-email-hannes@cmpxchg.org>
	<1322062951-1756-4-git-send-email-hannes@cmpxchg.org>
Date: Mon, 28 Nov 2011 06:15:05 +0530
Message-ID: <CAKTCnzkaWAnpbz+o3G=-mO1qUYKVjXaJwcCDYYt0SCspJdbe3g@mail.gmail.com>
Subject: Re: [patch 3/8] mm: memcg: clean up fault accounting
From: Balbir Singh <bsingharora@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, cgroups@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 9:12 PM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> From: Johannes Weiner <jweiner@redhat.com>
>
> The fault accounting functions have a single, memcg-internal user, so
> they don't need to be global.  In fact, their one-line bodies can be
> directly folded into the caller.  And since faults happen one at a
> time, use this_cpu_inc() directly instead of this_cpu_add(foo, 1).
>

Acked-by: Balbir Singh <bsingharora@gmail.com>

Balbir Singh
