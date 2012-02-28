Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab2B1Amk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 19:42:40 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49718 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568Ab2B1Amj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 19:42:39 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 28 Feb 2012 09:41:09 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v3 10/21] mm: kill struct mem_cgroup_zone
Message-Id: <20120228094109.e1b96c22.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20120223135229.12988.66375.stgit@zurg>
References: <20120223133728.12988.5432.stgit@zurg>
	<20120223135229.12988.66375.stgit@zurg>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Feb 2012 17:52:29 +0400
Konstantin Khlebnikov <khlebnikov@openvz.org> wrote:

> struct mem_cgroup_zone always points to one lruvec, either root zone->lruvec or
> to some from memcg. So this fancy pointer can be replaced with direct pointer to
> struct lruvec, because all required infromation already collected on lruvec.
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


